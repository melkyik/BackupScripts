.".\MyLibrary.ps1" 

$iniObj = Get-IniFile "Config.ini"
$token = $iniObj.TELEG.token

# URL Telegram API
$apiUrl ="https://api.telegram.org/bot$token"
# Путь к папке со скриптами

$scriptsFolder = $iniObj.PATHS.ScriptsFolder #"c:\Users\ik1\Documents\code\BackupScripts\"

# Функция для выполнения скриптов
function Invoke-Script($scriptName) {
    $scriptPath = Join-Path -Path $scriptsFolder -ChildPath $scriptName

    # Проверка существования файла скрипта
    if (Test-Path $scriptPath -PathType Leaf) {
        try {
            # Чтение содержимого скрипта
            $scriptContent = Get-Content $scriptPath -Raw

            # Выполнение скрипта
            Invoke-Expression -Command $scriptContent
        }
        catch {
            $errorMessage = "Ошибка при выполнении скрипта $($scriptPath): $_"
            Send-Telegram ($errorMessage)
            Write-Host $errorMessage
        }
    }
    else {
        $errorMessage = "Скрипт $($scriptName) не найден"
        Send-Telegram ($errorMessage)
    }
}


# Получение обновлений
$updatesUrl = "$apiUrl/getUpdates"
$response = Invoke-WebRequest -Uri $updatesUrl -Method Get

$data = $response | ConvertFrom-Json

foreach ($update in $data.result) {
    $message = $update.message

    # Обработка только текстовых сообщений
    if ($message -and $message.text) {
        $text = $message.text

        # Проверка, что сообщение содержит команду
        if ($text.StartsWith("/run ")) {
            # Извлечение имени скрипта из сообщения
            $scriptName = $text.Substring(5)

            # Выполнение скрипта
            Invoke-Script $scriptName
        }
        
    }
    $updateId = $update.update_id
    # Установка нового значения offset
    $offset = $updateId + 1
    # Вызов метода getUpdates с параметром offset
    $url = "$apiUrl/getUpdates?offset=$offset"
    Invoke-WebRequest -Uri $url -Method Get | Out-Null
}



# Задержка перед завершением скрипта
Write-Host "пауза 5 сек перед закрытием"
Start-Sleep -Seconds 5