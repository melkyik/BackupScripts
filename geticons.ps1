$folderName = Get-ChildItem "$env:userprofile\Documents" -Directory | Where-Object {$_.Name -match "simple-scada"};`
if ($folderName) {    Write-Host "found: $($folderName.FullName)"; `
    Invoke-WebRequest -URI "https://asu.ifarmproject.ru/s/kfKKoEjs3mbyXF5/download" -outfile "$($folderName.FullName)/Pictures.zip";`
    Expand-Archive -Path "$($folderName.FullName)/Pictures.zip"  -DestinationPath $($folderName.FullName) -Force;}`
    else { Write-Host "PATH NOT FOUND"}
