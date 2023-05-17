function rebenv($inName, $url, $inlogin, $inPassword, $localpath)
{ 
$fPass = convertto-securestring -AsPlainText -Force -String $inPassword 
$fcred = new-object -typename System.Management.Automation.PSCredential -argumentlist $inlogin,$fPass
Write-Host "Connecting $inName ip: $url"
try {
$fsession = new-pssession -computername $url -credential $fcred -SessionOption (New-PSSessionOption -OpenTimeout 20)
}
catch {
    Write-Host "connect failed $($url): $_"
    return
}
Write-Host "executing $localpath"
Invoke-Command -Session $fsession -ScriptBlock {param($path) Start-Process $path -Verb RunAs} -ArgumentList $localpath
Remove-PSSession $fsession
Write-Host "disconnected $inName "
}


 
$wnduser1="iFarm"
$wndpass1="123456789"
rebenv "внуково" 10.10.9.21 $wnduser1 $wndpass1 "C:\Users\iFarm\Downloads\env-installer\env-installer\app_start.bat"
rebenv "благовещенск" 10.10.22.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Downloads\env-installer\app_start.bat"
rebenv "красно€рск" 10.10.11.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Downloads\env-installer\app_start.bat"
rebenv "миасс" 10.10.20.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Downloads\env-installer\app_start.bat"
rebenv "Ёр–и€д" 10.10.23.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Downloads\env-installer\app_start.bat"


<#
rebenv "внуково" 10.10.9.21 $wnduser1 $wndpass1 "C:\Users\iFarm\Downloads\env-installer\env-installer"
$fPass = convertto-securestring -AsPlainText -Force -String $wndpass1 
$fcred = new-object -TypeName System.Management.Automation.PSCredential -argumentlist $wnduser1,$fPass
$fsession = new-pssession -ComputerName 10.10.9.21 -Credential $fCred
#Enter-PSSession -Session $fsession


Invoke-Command -Session $fsession -ScriptBlock {Start-Process "C:\Users\iFarm\Downloads\env-installer\env-installer\app_start.bat" -Verb RunAs}
#Remove-PSSession $fsession
#>

