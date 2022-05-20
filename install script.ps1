Set-NetFirewallRule -name vm-monitoring-icmpv4 -Enabled true;`
Set-ExecutionPolicy Bypass -Scope Process -Force; `
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); `
Invoke-WebRequest -URI "https://simple-scada.com/downloads/255000_426A5714-9647-4A97-808D/Simple-Scada%202.5.13.0.exe" `
-outfile "C:\Users\ifarm\Downloads\simplescada.exe";`
cd "C:\Users\ifarm\Downloads\"; `
.\simplescada.exe /VERYSILENT /TYPE="Full"`
Invoke-WebRequest -URI "https://asu.ifarmproject.ru/s/xtab3oKzJ5zkxRb/download" `
-outfile "C:\Users\ifarm\Downloads\eSearch_Utility_setup_Windows_v126.exe";`
cd "C:\Users\ifarm\Downloads\"; `
.\eSearch_Utility_setup_Windows_v126.exe /VERYSILENT /TYPE="Full";`
Invoke-WebRequest -URI "https://asu.ifarmproject.ru/s/mjc7fgLK86iqgPs/download" `
-outfile "C:\Users\ifarm\Downloads\WAGO-EthernetSettings-06.10.06.12.exe";`
cd "C:\Users\ifarm\Downloads\"; `
.\WAGO-EthernetSettings-06.10.06.12.exe /VERYSILENT /TYPE="Full";`
Invoke-WebRequest -URI "https://cloud.azcltd.com/index.php/s/MkWLtpM8C6ZsEXL/download" `
-outfile "C:\Users\ifarm\Downloads\env-installer.zip";`
cd "C:\Users\ifarm\Downloads\"; `
Expand-Archive -Path "C:\Users\ifarm\Downloads\env-installer.zip"  -DestinationPath "C:\Users\ifarm\Downloads" -Force;
cd "C:\Users\ifarm\Downloads\env-installer";.\install.bat
cinst -y 7zip firefox doublecmd libreoffice ;  