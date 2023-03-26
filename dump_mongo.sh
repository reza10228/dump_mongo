#!/bin/bash
Date=`date +%Y-%m-%d`
Service=prod
Mongo_Dir=/data/db/$Service/$Date
Directory=/backup/BackupSql/$Service/
host_Dir=/home/devops/mongo/MY_DB/Service/$Date/

Today=`date +%H-%M`
three_day=`date -d "3days ago" +'%F'`
Pass="xxxxxxxxxxxxxxxxxxx"
Expire=8

if [ ! -d $Directory ];
then
        mkdir -p /backup/BackupSql/$Service/$Date
fi
docker exec mongo-test mongodump  --host 192.168.111.17 --port 27017 --username root -p $Pass --authenticationDatabase admin --db db_prod --out $Mongo_Dir
mv  $host_Dir/ $Directory/

echo "dump is complete" >> /tmp/$Service.log
tar -czf $Directory/../$three_day/$Service-$Today.tar.gz $Directory/../$three_day/$Service-$Today.sql --remove-files
find $Directory/.. -type d -mtime +$Expire | xargs rm -rf
