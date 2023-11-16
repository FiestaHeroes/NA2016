# Make sure we're running as Administrator.
param([switch]$Elevated)
function Test-Admin
{
	$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
	$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Test-Admin) -eq $false)
{
	if ($elevated)
	{
		Write-Host "Tried to elevate, did not work... Exiting"
	}
	else
	{
		Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
	}
	Exit
}

# MessageBox.
Add-Type -AssemblyName PresentationFramework

# Restore / Install the databases.
Restore-SqlDatabase -ServerInstance ".\SQLEXPRESS" -Database "Account"              -BackupFile $PSScriptRoot"\Databases\Account.bak"
Restore-SqlDatabase -ServerInstance ".\SQLEXPRESS" -Database "AccountLog"           -BackupFile $PSScriptRoot"\Databases\AccountLog.bak"
Restore-SqlDatabase -ServerInstance ".\SQLEXPRESS" -Database "OperatorTool"         -BackupFile $PSScriptRoot"\Databases\OperatorTool.bak"
Restore-SqlDatabase -ServerInstance ".\SQLEXPRESS" -Database "StatisticsData"       -BackupFile $PSScriptRoot"\Databases\StatisticsData.bak"
Restore-SqlDatabase -ServerInstance ".\SQLEXPRESS" -Database "World00_Character"    -BackupFile $PSScriptRoot"\Databases\World00_Character.bak"
Restore-SqlDatabase -ServerInstance ".\SQLEXPRESS" -Database "World00_GameLog"      -BackupFile $PSScriptRoot"\Databases\World00_GameLog.bak"
Restore-SqlDatabase -ServerInstance ".\SQLEXPRESS" -Database "Options"      -BackupFile $PSScriptRoot"\Databases\Options.bak"

[System.Windows.MessageBox]::Show('Databases have been restored.')