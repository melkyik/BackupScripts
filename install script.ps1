#1 часть создание юзера
New-LocalUser -Name "iFarm"`
 -Password (ConvertTo-SecureString -String "123456789" -AsPlainText -Force) `
 -PasswordNeverExpires `
 -Description "IFarm operator";`
Add-LocalGroupMember -Group администраторы -Member "iFarm";`
Enable-LocalUser -name "iFarm";`
#под новым пользователем
Set-NetFirewallRule -name vm-monitoring-icmpv4 -Enabled true;`
Enable-PSRemoting;`
$uname = [System.Environment]::UserName;`
Set-ExecutionPolicy Bypass -Scope Process -Force;`
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'));`
Invoke-WebRequest -URI "https://asu.ifarmproject.ru/s/E2B6qsk7xKEMPjX/download" `
-outfile "C:\Users\$uname\Downloads\simplescada.exe";`
cd "C:\Users\$uname\Downloads\"; `
.\simplescada.exe /VERYSILENT /TYPE="Full";`
Invoke-WebRequest -URI "https://asu.ifarmproject.ru/s/xtab3oKzJ5zkxRb/download" `
-outfile "C:\Users\$uname\Downloads\eSearch_Utility_setup_Windows_v126.exe";`
cd "C:\Users\$uname\Downloads\"; `
.\eSearch_Utility_setup_Windows_v126.exe /VERYSILENT /TYPE="Full";`
Invoke-WebRequest -URI "https://asu.ifarmproject.ru/s/mjc7fgLK86iqgPs/download" `
-outfile "C:\Users\$uname\Downloads\WAGO-EthernetSettings-06.10.06.12.exe";`
cd "C:\Users\$uname\Downloads\"; `
.\WAGO-EthernetSettings-06.10.06.12.exe /VERYSILENT /TYPE="Full";`
Invoke-WebRequest -URI "https://cloud.azcltd.com/index.php/s/MkWLtpM8C6ZsEXL/download" `
-outfile "C:\Users\$uname\Downloads\env-installer.zip";`
cd "C:\Users\$uname\Downloads\"; `
Expand-Archive -Path "C:\Users\$uname\Downloads\env-installer.zip"  -DestinationPath "C:\users\$uname\Downloads" -Force;`
cd "C:\Users\$uname\Downloads\env-installer";.\install.bat;`
cinst -y 7zip firefox doublecmd   

