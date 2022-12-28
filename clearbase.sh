#!/bin/bash
#-------------------------------------------------
#скрипт делает очистку старых данных в базе simplescada и запускает оптимизацию для сжатия места
#-------------------------------------------------
db=$1
user="bdadmin"
passw="adminsa123"
if [ -z $db ]
then
echo "no base"
else
echo "DBname: $db"
echo 'Clearing trends_data for 6 months....'

mysql -u$user -p$passw "--database=$db" <<EOFMYSQL
SET @sdt=DATE_ADD(NOW(),INTERVAL -6 MONTH);
DELETE FROM trends_data WHERE TIMESTAMP < @sdt;
EOFMYSQL

echo 'optimising bd...'
mysqlcheck -o $db  -u$user -p$passw

echo "inserting data"
mysql -u$user -p$passw "--database=$db" <<EOFMYSQL
SET @sdt=DATE_ADD(NOW(),INTERVAL -6 MONTH);
INSERT IGNORE INTO trends_data (ID,TIMESTAMP,VALUE,Quality)
SELECT ID,TIMESTAMP,VALUE,Quality fROM trends_minute WHERE TIMESTAMP < @sdt ;
EOFMYSQL


fi