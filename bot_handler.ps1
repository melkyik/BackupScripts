.".\MyLibrary.ps1" 

$iniObj = Get-IniFile "Config.ini"
$token = $iniObj.TELEG.token

# URL Telegram API
$apiUrl ="https://api.telegram.org/bot$token"
# ���� � ����� �� ���������

$scriptsFolder = $iniObj.PATHS.ScriptsFolder #"c:\Users\ik1\Documents\code\BackupScripts\"

# ������� ��� ���������� ��������
function Invoke-Script($scriptName) {
    $scriptPath = Join-Path -Path $scriptsFolder -ChildPath $scriptName

    # �������� ������������� ����� �������
    if (Test-Path $scriptPath -PathType Leaf) {
        try {
            # ������ ����������� �������
            $scriptContent = Get-Content $scriptPath -Raw

            # ���������� �������
            Invoke-Expression -Command $scriptContent
        }
        catch {
            $errorMessage = "������ ��� ���������� ������� $($scriptPath): $_"
            Send-Telegram ($errorMessage)
            Write-Host $errorMessage
        }
    }
    else {
        $errorMessage = "������ $($scriptName) �� ������"
        Send-Telegram ($errorMessage)
    }
}


# ��������� ����������
$updatesUrl = "$apiUrl/getUpdates"
$response = Invoke-WebRequest -Uri $updatesUrl -Method Get

$data = $response | ConvertFrom-Json

foreach ($update in $data.result) {
    $message = $update.message

    # ��������� ������ ��������� ���������
    if ($message -and $message.text) {
        $text = $message.text

        # ��������, ��� ��������� �������� �������
        if ($text.StartsWith("/run ")) {
            # ���������� ����� ������� �� ���������
            $scriptName = $text.Substring(5)

            # ���������� �������
            Invoke-Script $scriptName
        }
        
    }
    $updateId = $update.update_id
    # ��������� ������ �������� offset
    $offset = $updateId + 1
    # ����� ������ getUpdates � ���������� offset
    $url = "$apiUrl/getUpdates?offset=$offset"
    Invoke-WebRequest -Uri $url -Method Get | Out-Null
}



# �������� ����� ����������� �������
Write-Host "����� 5 ��� ����� ���������"
Start-Sleep -Seconds 5