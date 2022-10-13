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

# Start the Services
sc.exe start _Account
sc.exe start _AccountLog
sc.exe start _Login
sc.exe start _Character
sc.exe start _GameLog
sc.exe start _WorldManager
sc.exe start _GamigoZR
TIMEOUT /T 5
sc.exe start _Zone0
sc.exe start _Zone1
sc.exe start _Zone2
sc.exe start _Zone3
sc.exe start _Zone4