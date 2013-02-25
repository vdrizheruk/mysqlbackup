#!/bin/bash

##########################################################################

if [ ! -e "$BACKUPFOLDER" ]; then
	mkdir -p $BACKUPFOLDER
fi

DAYS=$(DAYS-1)
cd $BACKUPFOLDER
find $DUMPPREFIX* -mtime +$DAYS -exec rm -f {} \;

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
    $CMDDUMP $db > $BACKUPFOLDER/$db-$DUMPNAME
  fi
done