# Ensure the script is running with Administrator privileges.
param([switch]$Elevated)

# Function to check if the script is running as an Administrator
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Check if we need to elevate privileges
if (-not (Test-Admin)) {
    if ($Elevated) {
        Write-Host "Attempted to elevate, but it did not succeed. Exiting..."
    } else {
        # Restart the script with elevated permissions
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -Elevated' -f ($myinvocation.MyCommand.Definition))
    }
    Exit
}

# Function to restart the SQL Server (SQLEXPRESS) service and wait until it is running
function Restart-SQLService {
    $serviceName = "SQL Server (SQLEXPRESS)"
    Write-Host "Restarting the SQL Server service: $serviceName"
    Restart-Service -Name $serviceName -Force

    # Wait for the service to be running
    Write-Host "Waiting for the SQL Server service to be running..."
    do {
        Start-Sleep -Seconds 5
        $serviceStatus = Get-Service -Name $serviceName
    } while ($serviceStatus.Status -ne 'Running')
    
    Write-Host "SQL Server service is running."
}

# Restart the SQL Server service
Restart-SQLService

# Set the path to the databases directory
$databasesPath = Join-Path $PSScriptRoot 'Databases'

# Check if the databases directory exists
if (Test-Path $databasesPath) {
    # Attempt to grant Full Control permissions to the SQL Server service account
    try {
        icacls $databasesPath /grant "NT SERVICE\MSSQL`$SQLEXPRESS:(OI)(CI)F" /T
        Write-Host "Permissions set successfully for the databases directory."
    } catch {
        Write-Host "Failed to set permissions: $_"
    }
} else {
    Write-Host "The databases directory does not exist: $databasesPath"
    Exit
}

# Load the PresentationFramework assembly to display message boxes
Add-Type -AssemblyName PresentationFramework

# Restore the specified SQL databases from backup files
$databasesToRestore = @(
    @{ Name = "Account"; BackupFile = "Account.bak" },
    @{ Name = "AccountLog"; BackupFile = "AccountLog.bak" },
    @{ Name = "OperatorTool"; BackupFile = "OperatorTool.bak" },
    @{ Name = "StatisticsData"; BackupFile = "StatisticsData.bak" },
    @{ Name = "World00_Character"; BackupFile = "World00_Character.bak" },
    @{ Name = "World00_GameLog"; BackupFile = "World00_GameLog.bak" },
    @{ Name = "Options"; BackupFile = "Options.bak" }
)

# Loop through each database and restore from its respective backup file
foreach ($db in $databasesToRestore) {
    Restore-SqlDatabase -ServerInstance ".\SQLEXPRESS" -Database $db.Name -BackupFile (Join-Path $PSScriptRoot "Databases\$($db.BackupFile)")
}

# Notify the user that all databases have been restored
[System.Windows.MessageBox]::Show('Databases have been successfully restored.')
