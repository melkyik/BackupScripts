#скрипт копирует средствами PS. ничего расшаривать не надо. Пароли в переменных могут повторятся 
#обязательные команды на удаленной машине
#выполнить на удаленной машине
#Enable-PSRemoting
#set-item wsman:localhost\client\trustedhosts -value 10.10.0.252
#строчка выше не обязательна иногда
#Set-PSSessionConfiguration -Name Microsoft.PowerShell -showSecurityDescriptorUI необязательно но может пригодится.

#выполнить у нас под админской PS нижеприведенный скрипт. Он делает set-item wsman:localhost\client\trustedhosts -value  но с добавлением в конец. 
#на основной машине должно быть много ИП разрешенных на удаленной не обязательно.
#.\Add-TrustedHost.ps1 10.10.9.20Enter-PSSession -ComputerName 10.10.9.21 -Credential (Get-Credential)
#проверка 
#или
#$cn = read-host 'ip?';  Enter-PSSession -ComputerName $cn -Credential (Get-Credential)
# .\Add-TrustedHost.ps1 10.10.9.21 ;`
# .\Add-TrustedHost.ps1 10.10.11.20 ;`
# .\Add-TrustedHost.ps1 10.10.7.20;`
# .\Add-TrustedHost.ps1 10.10.8.20;`
# .\Add-TrustedHost.ps1 10.10.4.20;`
# .\Add-TrustedHost.ps1 10.10.12.20;`
# .\Add-TrustedHost.ps1 10.10.20.20;`
# .\Add-TrustedHost.ps1 10.10.19.20;`
# .\Add-TrustedHost.ps1 10.10.21.20;`

.".\MyLibrary.ps1" 

$iniObj = Get-IniFile "Config.ini"
 
$pathcopyto=$iniObj.PATHS.BackupPath
$archivepath=$iniObj.PATHS.ArchivePath
$wnduser1=$iniObj.CREDSWIND.User1
$wndpass1=$iniObj.CREDSWIND.pass1

if(!(Test-Path -Path "$pathcopyto" )){
    New-Item -ItemType directory -Path "$pathcopyto"
 } 

#вызов функции параметры  имя        ип          юзер    пароль       путь удаленной машины                 наш путь
DownloadProjectDirectory "Внуково BIG" 10.10.9.21 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\vnukovo_REC" $pathcopyto
DownloadProjectDirectory "Красноярск" 10.10.11.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\kras200_REC" $pathcopyto
#DownloadProjectDirectory "Флакон" 10.10.7.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\Msk" $pathcopyto
#DownloadProjectDirectory "Иркутск" 10.10.8.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\Irk" $pathcopyto
#DownloadProjectDirectory "Финляндия" 10.10.4.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\Fin" $pathcopyto
DownloadProjectDirectory "Швейцария" 10.10.12.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\yasai" $pathcopyto
DownloadProjectDirectory "Миасс" 10.10.20.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\miass" $pathcopyto
#DownloadProjectDirectory "Этномир" 10.10.19.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\Etnomir" $pathcopyto
DownloadProjectDirectory "Питер" 10.10.21.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\Peterburg" $pathcopyto
DownloadProjectDirectory "Франция" 10.10.15.20 $wnduser1 $wndpass1 "C:\Users\iFarm.DESKTOP-IOITOEP\Documents\Simple-Scada 2\Projects\capsum" $pathcopyto
DownloadProjectDirectory "Благовещенск" 10.10.22.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\blag" $pathcopyto
DownloadProjectDirectory "Эр-рияд" 10.10.23.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\GreenBasket" $pathcopyto
DownloadProjectDirectory "SpaceFarm" 10.10.24.20 $wnduser1 $wndpass1 "C:\Users\iFarm\Documents\Simple-Scada 2\Projects\SpaceFarm" $pathcopyto
#копируем исходники проектов
DownloadProjectDirectory "ПЛК Николаева" 10.10.5.20 $wnduser1 $wndpass1 "D:\!Project\Podval\*\*.pro" "$pathcopyto\Codesys\podval"

#Write-Host "Downloading Cloud"  
# if(!(Test-Path -Path "$pathcopyto\Cloud\" )){
#    New-Item -ItemType directory -Path "$pathcopyto\Cloud\"
# } 
Copy-Item  'C:\Users\Администратор.SERVER\Documents\Simple-Scada 2\Projects\' -Destination "$pathcopyto\Cloud\" -Recurse -force #локальный проект

$strdatetime =Get-Date -Format "yyyy-MM-dd_HH-mm"
if(!(Test-Path -Path $archivepath )){
    New-Item -ItemType directory -Path $archivepath
} 
Compress-Archive -DestinationPath $archivepath"ProjectScada_$strdatetime" -Path $pathcopyto\*

$wnduser1=""
$wndpass1=""
if($pathcopyto -ne "") {Remove-Item -Path $pathcopyto\* -recurse}

