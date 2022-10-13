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

# Stop the Services
sc.exe stop _Account
sc.exe stop _AccountLog
sc.exe stop _Login
sc.exe stop _Character
sc.exe stop _GameLog
sc.exe stop _WorldManager
sc.exe stop _GamigoZR
sc.exe stop _Zone0
sc.exe stop _Zone1
sc.exe stop _Zone2
sc.exe stop _Zone3
sc.exe stop _Zone4