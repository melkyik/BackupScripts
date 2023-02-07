Пример файла Config.ini

```
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
```


-  <b>MyLibrary.ps1</b> - библиотека с разными функциями чтение файлла ini, копирование удаленного пути , фтп , отсылка телеги
-  <b>GetRecipesFTP.ps1</b>   - грузит данные с контроллеров для создания архива с бакапами
-  <b>Add-TrustedHost.ps1</b>  - добавляет доверенный хост для PSremoting
-  <b>SendTOBitrix.ps1</b>  - скрипт отсылки архивов в битрикс SendTelegram.ps1 - отсылка телеграмм с командной строки
