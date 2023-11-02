<#
.SYNOPSIS
Checks the status of 'ip http server' and 'ip http secure-server' on all networking devices

.DESCRIPTION
This script is in direct response to CVE-2023-20198 and CVE-2023-20273 in which the http server on
Cisco IOS-XE devices can be used to gain unathorized access. This script will check the status of the
http server so you can identify which devices will need to be configured.

.NOTES
File Name        : Check-HttpServerStatus.ps1
Author           : Cadence James
Prerequisite     : Powershell Version 2.0 or newer (with plink installed)
                 : PuTTY Release 0.72 or newer
				 : 'inventory.csv' file
				 : Network Device Credentials
#>


$username = Read-Host -Prompt " Username"
$password = Read-Host -Prompt " Password" -AsSecureString
$temppass = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($password)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($temppass)
$stopwatch = [Diagnostics.Stopwatch]::StartNew()
if (! (Test-Path) ".\inventory.csv") ) { Write-Host " No 'inventory.csv' file found. Please verify" -ForegroundColor red; quit }
else { $devices = Import-Csv ".\inventory.csv" }
$outfile = ".\HTTP Server Output.txt"
New-Item -Path $outfile -Type file -Force | Out-Null
$counter = 1
foreach ($device in $devices) {
	write-progress -Activity "Checking configs" -Status "Processing Device $( $device.ip ) $( $counter of $( $devices.count ) )" -PercentComplete (($counter / $( $devices.count)) * 100)
	$testconnection = Test-Connection $( $device.ip ) -Count 1 -Quiet
	if ($testconnection -eq $True) {
		echo y | plink $( $device.ip ) -ssh
		$http = $( plink $( $device.ip ) -l $username -pw $password -batch "show run | i ip http server|secure|active" )
		Add-Content $outfile ""
		Add-Content $outfile "$( $device.ip ) - $( $device.hostname )"
		Add-Content $outfile "-----------------------"
		Add-Content $outfile $http
		Add-Content $outfile "======================================================================================="
	}
	else {
		Add-Content $outfile ""
		Add-Content $outfile "$( $device.ip ) - Unable to Reach"
		Add-Content $outfile "======================================================================================="
	}
	$counter++
	Clear
}
$stopwatch.Stop()
Sleep(1)
Clear
Write-Host ""
Write-Host " Script ran in $( $stopwatch.Elapsed.Hours ) hours, $( $stopwatch.Elapsed.Minutes ) minutes, $( $stopwatch.Elapsed.Seconds ) seconds, $( $stopwatch.Elapsed.Milliseconds ) ms"
