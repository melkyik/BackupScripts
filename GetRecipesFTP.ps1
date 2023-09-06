
#вызовем  библиотеку s
. ".\MyLibrary.ps1"
$iniObj = Get-IniFile 'Config.ini'


$credentials = New-Object System.Net.NetworkCredential($iniObj.CREDSFTP.User1,$iniObj.CREDSFTP.pass1)
$credentials1 = New-Object System.Net.NetworkCredential($iniObj.CREDSFTP.User2,$iniObj.CREDSFTP.pass2)
$targetdir = $iniObj.PATHS.BackupPath
$archivepath=$iniObj.PATHS.ArchivePath


if(!(Test-Path -Path "$targetdir" )){
    New-Item -ItemType directory -Path "$targetdir"
 } 

$url = "ftp://10.10.9.29/PlcLogic/json/"
DownloadFtpDirectory $url $credentials1 $targetdir"vnukovobig"

$url = "ftp://10.10.5.30/PlcLogic/lcLogic/AllRecipes/"
DownloadFtpDirectory $url $credentials $targetdir"podval"

#$url = "ftp://10.10.1.30/PlcLogic/lcLogic/AllRecipes/"
#DownloadFtpDirectory $url $credentials $targetdir"lexus"

#$url = "ftp://10.10.4.30/PlcLogic/lcLogic/AllRecipes/"
#DownloadFtpDirectory $url $credentials $targetdir"fin"

#$url = "ftp://10.10.8.30/PlcLogic/lcLogic/AllRecipes/"
#DownloadFtpDirectory $url $credentials $targetdir"irk"

$url = "ftp://10.10.11.30/PlcLogic/json/"
DownloadFtpDirectory $url $credentials1 $targetdir"kras"

$url = "ftp://10.10.13.30/PlcLogic/json/"
DownloadFtpDirectory $url $credentials1 $targetdir"Berdsk"

$url = "ftp://10.10.12.30/PlcLogic/json/"
DownloadFtpDirectory $url $credentials1 $targetdir"Yasay"


#$url = "ftp://10.10.7.30/PlcLogic/lcLogic/AllRecipes/"
#DownloadFtpDirectory $url $credentials $targetdir"flakon"

$url = "ftp://10.10.20.30/PlcLogic/json/"
DownloadFtpDirectory $url $credentials1 $targetdir"Miass"


$url = "ftp://10.10.21.30/PlcLogic/json/"
DownloadFtpDirectory $url $credentials1 $targetdir"Piter FU1"

$url = "ftp://10.10.21.31/PlcLogic/json/"
DownloadFtpDirectory $url $credentials1 $targetdir"Piter FU2"

$url = "ftp://10.10.15.30/PlcLogic/json/"
DownloadFtpDirectory $url $credentials1 $targetdir"FRANCE"

$url = "ftp://10.10.22.30/PlcLogic/json/"
DownloadFtpDirectory $url $credentials1 $targetdir"Blagoveshensk"
#$url = "ftp://10.10.23.30/PlcLogic/json/"
#DownloadFtpDirectory $url $credentials1 $targetdir"ErRyad"
$url = "ftp://10.10.24.30/PlcLogic/json/"
DownloadFtpDirectory $url $credentials1 $targetdir"Spacefarm"

if(!(Test-Path -Path $archivepath)){
    New-Item -ItemType directory -Path  $archivepath
} 

$strdatetime =Get-Date -Format "yyyy-MM-dd_HH-mm"

Compress-Archive -DestinationPath $archivepath"RecipesBackup_$strdatetime" -Path $targetdir*
if($targetdir -ne "") { Remove-Item -Path $targetdir* -recurse}