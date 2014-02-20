Echo off
Echo Author Jan Hebnes / jhe@1508.dk
Echo Created 2014-02-20 
Echo.
Echo Purpose is to monitor health on mssql database installations and send one report to an email with detailed attached

echo DEVX > DatabaseStorageUsage.txt
Sqlcmd -S devX -E -v ServerName = "devX" -i DatabaseStorageUsageQuery.sql >> DatabaseStorageUsage.txt
echo UATX >> DatabaseStorageUsage.txt
Sqlcmd -S uatX -E -v ServerName = "uatX" -i DatabaseStorageUsageQuery.sql >> DatabaseStorageUsage.txt
echo PRODX >> DatabaseStorageUsage.txt
Sqlcmd -S prodx -E -v ServerName = "prodX" -i DatabaseStorageUsageQuery.sql >> DatabaseStorageUsage.txt

echo Please find attached today's top fat databases report >> body.txt
echo. >> body.txt
echo. List of 1+ GB Databases (size_on_disk / num_of_bytes_read / num_of_bytes_written) >> body.txt
echo. >> body.txt
echo DEVX >> body.txt
Sqlcmd -S devX -E -v ServerName = "devX" -i DatabaseStorageUsageShortQuery.sql -h-1 >>body.txt
echo. >> body.txt
echo UATX >> body.txt
Sqlcmd -S uatX -E -v ServerName = "uatX" -i DatabaseStorageUsageShortQuery.sql -h-1 >> body.txt
echo. >> body.txt
echo PRODX >> body.txt
Sqlcmd -S prodX -E -v ServerName = "prodX" -i DatabaseStorageUsageShortQuery.sql -h-1 >> body.txt
echo. >> body.txt
echo More details can be found in the attached DatabaseStorageUsage.txt >> body.txt

mpack -s "Database Usage Report" -d body.txt -o body.msg DatabaseStorageUsage.txt
bmail -s smtp.server.com -t to@yourdomain.com -f from@yourdomain.com -h -m body.msg

DEL DatabaseStorageUsage.txt
DEL body.msg
DEL body.txt

echo Done