param(
[string]$message = 'test'
)
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
[Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"


$bot_token = "tokend123213123dgfgdfgdfg"
$uri = "https://api.telegram.org/bot$bot_token/sendMessage"

$id = "345821176" #повторить для каждого получателя
Invoke-WebRequest -Method Post -Uri $uri -ContentType "application/json;charset=utf-8" -Body (ConvertTo-Json -Compress -InputObject @{chat_id=$id; text=$message})

# $id = "400374928"
# Invoke-WebRequest -Method Post -Uri $uri -ContentType "application/json;charset=utf-8" 
# -Body (ConvertTo-Json -Compress -InputObject @{chat_id=$id; text=$message})

