# Ensure the script is running with Administrator privileges.
param([switch]$Elevated)

# Function to check if the script is running as an Administrator
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
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

# MessageBox.
Add-Type -AssemblyName PresentationFramework

# Delete the databases.
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database Account;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database AccountLog;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database OperatorTool;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database StatisticsData;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database World00_Character;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database World00_GameLog;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database Options;"

[System.Windows.MessageBox]::Show('Databases have been deleted.')
