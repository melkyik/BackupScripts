Пример файла Config.ini


[PATHS]
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
pass=pass



MyLibrary.ps1 - библиотека с разными функциями чтение файлла ини, копирование удаленного пути , фтп , отсылка телеги
GetRecipesFTP.ps1  - грузит данные с контроллеров для создания архива с бакапами
Add-TrustedHost.ps1 - добавляет доверенный хост для PSremoting
SendTOBitrix.ps1 - скрипт отсылки архивов в битрикс SendTelegram.ps1 - отсылка телеграмм с командной строки