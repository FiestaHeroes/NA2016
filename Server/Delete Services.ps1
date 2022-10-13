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
sc.exe delete _Account
sc.exe delete _AccountLog
sc.exe delete _Login
sc.exe delete _Character
sc.exe delete _GameLog
sc.exe delete _WorldManager
sc.exe delete _GamigoZR
sc.exe delete _Zone0
sc.exe delete _Zone1
sc.exe delete _Zone2
sc.exe delete _Zone3
sc.exe delete _Zone4