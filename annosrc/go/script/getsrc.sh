#!/bin/sh
set -e
if [ "$GOSOURCEDATE" = "" ]; then
  . ./env.sh
fi

## unpack source data
GOTERM_DIR=go_$GOSOURCEDATE-termdb-tables
GOTERM_TAR=$GOTERM_DIR.tar.gz
cd ../$GOSOURCEDATE
rm -rf $GOTERM_DIR
tar xvfz $GOTERM_TAR
rm -f goterm
ln -s $GOTERM_DIR goterm

## create source sqlite db
rm -f gosrcsrc.sqlite
sqlite3 -bail gosrcsrc.sqlite < ../script/srcdb.sql

## record data download date
echo "INSERT INTO metadata VALUES('GOSOURCENAME', '$GOSOURCENAME');" > temp_metadata.sql
echo "INSERT INTO metadata VALUES('GOSOURCEURL', '$GOSOURCEURL');" >> temp_metadata.sql
echo "INSERT INTO metadata VALUES('GOSOURCEDATE', '$GOSOURCEDATE');" >> temp_metadata.sql
sqlite3 -bail gosrcsrc.sqlite < temp_metadata.sql
rm -f temp_metadata.sql
