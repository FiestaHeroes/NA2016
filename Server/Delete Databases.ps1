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

# Delete the databases.
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database Account;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database AccountLog;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database OperatorTool;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database StatisticsData;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database World00_Character;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database World00_GameLog;"
invoke-sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "Drop database Options;"

[System.Windows.MessageBox]::Show('Databases have been deleted.')