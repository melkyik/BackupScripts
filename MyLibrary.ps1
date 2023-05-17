[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
Function defConfigIni($Filename) {
    if(!(Test-Path -Path  $Filename  )){
        Write-Host "Создан Файл $Filename по умолчанию!"
        Add-Content -Path $Filename -Value "[PATHS]
BackupPath=C:/temp/backup/
ArchivePath=C:/temp/ProjectsArchive/
[CREDSFTP]
User1=admin
pass1=pass
user2=admin
pass2=pass
[CREDSWIND]
User1=iFarm
pass1=pass
[TELEG]
token=asdfasdfasdfasdfadfasdfasdfasdf
[BITRIX]
User=user
pass=pass"
        
    } 
}
Function Get-IniFile ($file)       # Based on "https://stackoverflow.com/a/422529"
 {
    defConfigIni($file)
    $ini = [ordered]@{}

    # Create a default section if none exist in the file. Like a java prop file.
    $section = "NO_SECTION"
    $ini[$section] = [ordered]@{}

    switch -regex -file $file 
    {    
        "^\[(.+)\]$" 
        {
            $section = $matches[1].Trim()
            $ini[$section] = [ordered]@{}
        }

        "^\s*(.+?)\s*=\s*(.*)" 
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value.Trim()
        }

        default
        {
            $ini[$section]["<$("{0:d4}" -f $CommentCount++)>"] = $_
        }
    }

    $ini
}

Function Set-IniFile ($iniObject, $Path, $PrintNoSection=$false, $PreserveNonData=$true)
{                                  # Based on "http://www.out-web.net/?p=109"
    $Content = @()
    ForEach ($Category in $iniObject.Keys)
    {
        if ( ($Category -notlike 'NO_SECTION') -or $PrintNoSection )
        {
            # Put a newline before category as seperator, only if there is none 
            $seperator = if ($Content[$Content.Count - 1] -eq "") {} else { "`n" }

            $Content += $seperator + "[$Category]";
        }

        ForEach ($Key in $iniObject.$Category.Keys)
        {           
            if ( $Key.StartsWith('<') )
            {
                if ($PreserveNonData)
                    {
                        $Content += $iniObject.$Category.$Key
                    }
            }
            else
            {
                $Content += "$Key = " + $iniObject.$Category.$Key
            }
        }
    }

    $Content | Set-Content $Path -Force
}
### EXAMPLE
##
## $iniObj = Get-IniFile 'c:\myfile.ini'
##
## $iniObj.existingCategory1.exisitingKey = 'value0'
## $iniObj['newCategory'] = @{
##   'newKey1' = 'value1';
##   'newKey2' = 'value2'
##   }
## $iniObj.existingCategory1.insert(0, 'keyAtFirstPlace', 'value3')
## $iniObj.remove('existingCategory2')
##
## Set-IniFile $iniObj 'c:\myNewfile.ini' -PreserveNonData $false
##




#================== функция отправки телеги
function Send-Telegram ($message) {

    $psDefaultParams = New-Object System.Collections.Hashtable
    $psDefaultParams.Add("Out-File:Encoding", [System.Text.Encoding]::UTF8)
    $PSDefaultParameterValues = $psDefaultParams

[Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"


$bot_token = $iniObj.TELEG.token
$uri = "https://api.telegram.org/bot$bot_token/sendMessage"

$id = "345821176" #повторить для каждого получателя
Invoke-WebRequest -Method Post -Uri $uri -ContentType "application/json;charset=utf-8" `
-Body (ConvertTo-Json -Compress -InputObject @{chat_id=$id; text=$message})

}


#===============загрузка папки из фтп
function DownloadFtpDirectory($url, $credentials, $localPath)
{
if(!(Test-Path -Path $localPath )){
    New-Item -ItemType directory -Path $localPath
}
    $listRequest = [Net.WebRequest]::Create($url)
    $listRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails
    $listRequest.Credentials = $credentials

    $lines = New-Object System.Collections.ArrayList
try{
    $listResponse = $listRequest.GetResponse()
    $listStream = $listResponse.GetResponseStream()
    $listReader = New-Object System.IO.StreamReader($listStream)
    while (!$listReader.EndOfStream)
    {
        $line = $listReader.ReadLine()
        $lines.Add($line) | Out-Null
    }
    $listReader.Dispose()
    $listStream.Dispose()
    $listResponse.Dispose()

    foreach ($line in $lines)
    {
        $tokens = $line.Split(" ", 9, [StringSplitOptions]::RemoveEmptyEntries)
        $name = $tokens[8]
        $permissions = $tokens[0]

        $localFilePath = Join-Path $localPath $name
        $fileUrl = ($url + $name)

        if ($permissions[0] -eq 'd')
        {
            if (!(Test-Path $localFilePath -PathType container))
            {
                Write-Host "Creating directory $localFilePath"
                New-Item $localFilePath -Type directory | Out-Null
            }

            DownloadFtpDirectory ($fileUrl + "/") $credentials $localFilePath
        }
        else
        {
            Write-Host "Downloading $fileUrl to $localFilePath"

            $downloadRequest = [Net.WebRequest]::Create($fileUrl)
            $downloadRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
            $downloadRequest.Credentials = $credentials

            $downloadResponse = $downloadRequest.GetResponse()
            $sourceStream = $downloadResponse.GetResponseStream()
            $targetStream = [System.IO.File]::Create($localFilePath)
            $buffer = New-Object byte[] 10240
            while (($read = $sourceStream.Read($buffer, 0, $buffer.Length)) -gt 0)
            {
                $targetStream.Write($buffer, 0, $read);
            }
            $targetStream.Dispose()
            $sourceStream.Dispose()
            $downloadResponse.Dispose()
        }
    }
}#try
catch
{
    Send-Telegram ("Loading recipes script: 
    Error loading project $Url")
     Write-Host "Downloading $Url Failed!!"
}
}
#функция загрузки через powershell 
function DownloadProjectDirectory($inName, $url, $inlogin, $inPassword, $localpath, $targetpath)
{ 
$fPass = convertto-securestring -AsPlainText -Force -String $inPassword 
$fcred = new-object -typename System.Management.Automation.PSCredential -argumentlist $inlogin,$fPass


try {
if(!(Test-Path -Path $targetpath )){
    New-Item -ItemType directory -Path $targetpath
} 
Write-Host "Connecting $inName ip: $url"
$fsession = new-pssession -computername $url -credential $fCred
Write-Host "Downloading $inName ip: $url"
Copy-Item   $localpath -Destination $targetpath -Recurse -force  -FromSession $fsession  
}
catch {
    Send-Telegram ( "Loading scada projects script: 
 Error loading project $inName ip: $Url")


Write-Host "COPY FAIL! $inName ip: $url"
}
}#конец функции

function ConvertTo-Encoding ([string]$From, [string]$To){
    Begin{
        $encFrom = [System.Text.Encoding]::GetEncoding($from)
        $encTo = [System.Text.Encoding]::GetEncoding($to)
    }
    Process{
        $bytes = $encTo.GetBytes($_)
        $bytes = [System.Text.Encoding]::Convert($encFrom, $encTo, $bytes)
        $encTo.GetString($bytes)
    }
}
<#загрузка файла на удаленную машину 
пример
.".\MyLibrary.ps1" 
$wnduser1 = "ifarm"
$wndpass1="pass"
$targetfile="C:\Users\Администратор.SERVER\Downloads\Simple-Scada 2.6.3.3.exe" 
$remotepath="C:\Users\ifarm\Downloads"
 
UploadFile "Внуково BIG" 10.10.9.21 $wnduser1 $wndpass1 $targetfile  $remotepath
UploadFile "Красноярск" 10.10.11.20 $wnduser1 $wndpass1 $targetfile  $remotepath
UploadFile "Флакон" 10.10.7.20 $wnduser1 $wndpass1 $targetfile  $remotepath
UploadFile "Иркутск" 10.10.8.20 $wnduser1 $wndpass1 $targetfile  $remotepath
UploadFile "Швейцария" 10.10.12.20 $wnduser1 $wndpass1 $targetfile  $remotepath
UploadFile "Миасс" 10.10.20.20 $wnduser1 $wndpass1 $targetfile $remotepath
UploadFile "Этномир" 10.10.19.20 $wnduser1 $wndpass1 $targetfile $remotepath
UploadFile "Питер" 10.10.21.20 $wnduser1 $wndpass1 $targetfile $remotepath
UploadFile "Благовещенск" 10.10.22.20 $wnduser1 $wndpass1 $targetfile $remotepath
UploadFile "Франция" 10.10.15.20 $wnduser1 $wndpass1 $targetfile  "C:\Users\iFarm.DESKTOP-IOITOEP\downloads"
UploadFile "GreenBasket" 10.10.23.20 $wnduser1 $wndpass1 $targetfile  $remotepath
#>
function UploadFile($inName, $url, $inlogin, $inPassword, $localpath, $targetpath)
{ 
$fPass = convertto-securestring -AsPlainText -Force -String $inPassword 
$fcred = new-object -typename System.Management.Automation.PSCredential -argumentlist $inlogin,$fPass


try {
Write-Host "Connecting $inName ip: $url"
$fsession = new-pssession -computername $url -credential $fCred
Write-Host "Downloading $inName ip: $url"
Copy-Item   $localpath -Destination $targetpath -Recurse -force  -ToSession $fsession  

}
catch {
Write-Host "COPY FAIL! $inName ip: $url"
}
}
