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

# Install the Services
Start-Process -FilePath $PSScriptRoot"\Account\Account.exe"
Start-Process -FilePath $PSScriptRoot"\AccountLog\AccountLog.exe"
Start-Process -FilePath $PSScriptRoot"\Character\Character.exe"
Start-Process -FilePath $PSScriptRoot"\GameLog\GameLog.exe"
Start-Process -FilePath $PSScriptRoot"\Login\Login.exe"
Start-Process -FilePath $PSScriptRoot"\WorldManager\WorldManager.exe"
Start-Process -FilePath $PSScriptRoot"\Zone00\Zone.exe"
Start-Process -FilePath $PSScriptRoot"\Zone01\Zone.exe"
Start-Process -FilePath $PSScriptRoot"\Zone02\Zone.exe"
Start-Process -FilePath $PSScriptRoot"\Zone03\Zone.exe"
Start-Process -FilePath $PSScriptRoot"\Zone04\Zone.exe"
SC.exe CREATE "_GamigoZR" binpath= $PSScriptRoot"\GamigoZR\GamigoZR.exe"