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

# Setup the Firewall rules for the server. This will forward the required server ports.
netsh.exe advfirewall firewall add rule name="_NA2016" dir=in action=allow protocol=TCP localport=9010,9013,9016,9019,9022,9025,9028