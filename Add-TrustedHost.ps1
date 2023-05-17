######################################################################################
# добавляет NewHost в список TrustedHost с фильтрацией если такая строка уже есть
# можно дергать из командной строки указывая параметр напрямую например
# .\Add-TrustedHost.ps1 192.168.2.1
<#
.\Add-TrustedHost.ps1 10.10.9.21 ;`
.\Add-TrustedHost.ps1 10.10.11.20 ;`
.\Add-TrustedHost.ps1 10.10.7.20;`
.\Add-TrustedHost.ps1 10.10.8.20;`
.\Add-TrustedHost.ps1 10.10.4.20;`
.\Add-TrustedHost.ps1 10.10.12.20;`
.\Add-TrustedHost.ps1 10.10.20.20;`
.\Add-TrustedHost.ps1 10.10.19.20;`
.\Add-TrustedHost.ps1 10.10.21.20;`
.\Add-TrustedHost.ps1 10.10.22.20;`
.\Add-TrustedHost.ps1 10.10.23.20;`
.\Add-TrustedHost.ps1 10.10.24.20;`
#>
######################################################################################
param ( $NewHost = '10.10.9.20' )

Write-Host "adding host: $NewHost"

$prev = (get-item WSMan:\localhost\Client\TrustedHosts).value
if ( ($prev.Contains( $NewHost )) -eq $false)
{ 
    if ( $prev -eq '' ) 
    { 
        set-item WSMan:\localhost\Client\TrustedHosts -Value "$NewHost" 
    }
    else
    {
        set-item WSMan:\localhost\Client\TrustedHosts -Value "$prev, $NewHost"
    }
}

Write-Host ''
Write-Host 'Now TrustedHosts contains:'
(get-item WSMan:\localhost\Client\TrustedHosts).value
