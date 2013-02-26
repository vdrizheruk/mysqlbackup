#!/bin/bash

source ./config.sh

if [ ! -e "$BACKUPFOLDER" ]; then
	mkdir -p $BACKUPFOLDER
fi

DAYS=$((DAYS-1))
cd $BACKUPFOLDER
find ../* -mtime +$DAYS -exec rm -rf {} \;

if [ "$DBNAME" == '*' ]; then
	DBLIST=`echo "show databases" | mysql -N -u $USER -p$PASSWD`
else
  DBLIST=$DBNAME
fi

for db in $DBLIST
do
  if [ "$CRYPT" == "true" ]; then
    $CMDDUMP $db | $CMDCRYPT $BACKUPFOLDER/$db-$DUMPNAME.gpg
  else
    $CMDDUMP $db | gzip -c > $BACKUPFOLDER/$db-$DUMPNAME.gz
  fi
done