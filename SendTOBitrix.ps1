

#Remove-Variable * -ErrorAction SilentlyContinue; Remove-Module *; $error.Clear(); Clear-Host
.".\MyLibrary.ps1" 
$iniObj = Get-IniFile 'Config.ini'
$pathToDisk = "Z:"
$pathToBackups = $iniObj.PATHS.ArchivePath
$birtixUser=$iniObj.BITRIX.user
$birtixpass=$iniObj.BITRIX.pass


try
{    
       
       if (-Not([System.IO.Directory]::Exists($pathToDisk)))
        {
            Write-Host "Mounting Disk"
            net use Z: "https://ifarmproject.bitrix24.ru/extranet/contacts/personal/user/340/disk/path/BackUp/" /User:$birtixUser $birtixpass
        }
        
        Start-Sleep -s 2
        
        if([System.IO.Directory]::Exists($pathToDisk))
        {#ыбираем два последних файла - с рецептами и с проектами
            Get-ChildItem -Path $pathToBackups -Filter "Recipes*.zip" | Sort-Object LastAccessTime -Descending | Select-Object -First 1 | % {
                $pathToLastBackup = "$pathToBackups\$_"
                $pathToDiskBackup = "$pathToDisk\$_"
               
            }

            Get-ChildItem -Path $pathToBackups -Filter "ProjectScada*.zip" | Sort-Object LastAccessTime -Descending | Select-Object -First 1 | % {
                $pathToLastBackup2 = "$pathToBackups\$_"
                $pathToDiskBackup2 = "$pathToDisk\$_"
             
            }
               #$strdatetime =Get-Date -Format "dd-MM-yyyy HH-mm"
             #  $archivename = "C:\ProjectsArchive\AllBackup_"+$strdatetime

            #Compress-Archive -DestinationPath $archivename -Path $pathToLastBackup , $pathToLastBackup2 
                   Write-Host "Uploading :$pathToLastBackup  -> $pathToDiskBackup"
                    
          #   [System.IO.File]::Copy($pathToLastBackup,$pathToDiskBackup)
             Copy-Item  $pathToLastBackup2 -Destination $pathToDiskBackup2 -Recurse -force
                  Start-Sleep -s 3
                  Write-Host "Uploading :$pathToLastBackup2  -> $pathToDiskBackup2"
             Copy-Item  $pathToLastBackup -Destination $pathToDiskBackup -Recurse -force
                 Start-Sleep -s 3
               net use Z: /delete 
        }

}
catch
{
   net use Z: /delete
}