#!/bin/sh

IVECHECKEDIT=$1

if [ -z "$IVECHECKEDIT" ]l; then
    echo "First read what is in the env.sh script and make sure the links are up to date\nAnd then re-run this script as ./download.sh TRUE"
    exit
fi

set -e
. ./env.sh

BASE_URL=$TAIRSOURCEURL

# There is actually no date checking - instead it's incumbent (for now) that all the URLs in env.sh get updated by hand by whomever runs this script.

# THIS_YEAR=`date|awk '{print $6}'`
# #LATEST_DATE=`curl --fail -s -L --disable-epsv $BASE_URL/|grep "User_Requests"|awk '{print $8 "-" $6 $7}'|sed -e "s/^[0-9]*:[0-9]*-/$THIS_YEAR-/g"`
 LATEST_DATE=2020-Apr01

if [ -z "$LATEST_DATE" ]; then
        echo "download.sh: User_Requests directory from $BASEURL not found"
        exit 1
fi

if [ "$LATEST_DATE" != "$TAIRSOURCEDATE" ]; then
      mkdir -p ../$TAIRSOURCEDATE
      cd ../$TAIRSOURCEDATE
      curl --fail -L -o $TAIRGENEURLNAME $TAIRGENEURL
      curl --fail -L -o $TAIRCHRURLNAME $TAIRCHRURL
      curl --fail -L -o $TAIRATHURLNAME $TAIRATHURL
      curl --fail -L -o $TAIRAGURLNAME  $TAIRAGURL
      curl --fail -L -o $TAIRGOURLNAME $TAIRGOURL
      curl --fail -L -o $TAIRSYMBOLURLNAME $TAIRSYMBOLURL
      curl --fail -L -o $TAIRPATHURLNAME $TAIRPATHURL
      curl --fail -L -o $TAIRPMIDURLNAME $TAIRPMIDURL
      curl --fail -L -o $TAIRGFFURLNAME $TAIRGFF
      cd ../script  
      #TAIRATHURL=`echo $TAIRATHURL|sed -e 's/\//\\\\\//g'`
      #TAIRAGURL=`echo $TAIRAGURL|sed -e 's/\//\\\\\//g'`
      #TAIRGOURL=`echo $TAIRGOURL|sed -e 's/\//\\\\\//g'`
      #TAIRSYMBOLURL=`echo $TAIRSYMBOLURL|sed -e 's/\//\\\\\//g'`
      #TAIRPATHURL=`echo $TAIRPATHURL|sed -e 's/\//\\\\\//g'`
      #TAIRPMIDURL=`echo $TAIRPMIDURL|sed -e 's/\//\\\\\//g'`
      echo "update $TAIRSOURCENAME data from $TAIRSOURCEDATE to $LATEST_DATE"
      #sed -i -e "s/ TAIRSOURCEDATE=.*$/ TAIRSOURCEDATE=$LATEST_DATE/g" env.sh    
      #sed -i -e "s/ TAIRATHURL=.*$/ TAIRATHURL=\"$TAIRATHURL\"/g" env.sh
      #sed -i -e "s/ TAIRAGURL=.*$/ TAIRAGURL=\"$TAIRAGURL\"/g" env.sh
      #sed -i -e "s/ TAIRGOURL=.*$/ TAIRGOURL=\"$TAIRGOURL\"/g" env.sh
      #sed -i -e "s/ TAIRSYMBOLURL=.*$/ TAIRSYMBOLURL=\"$TAIRSYMBOLURL\"/g" env.sh
      #sed -i -e "s/ TAIRPATHURL=.*$/ TAIRPATHURL=\"$TAIRPATHURL\"/g" env.sh
      #sed -i -e "s/ TAIRPMIDURL=.*$/ TAIRPMIDURL=\"$TAIRPMIDURL\"/g" env.sh
      #sh getsrc.sh
      ##Some post-processing (would be nicer if I made more variables here
    
      # In the following files, first line is column name
      cd ../$TAIRSOURCEDATE
      zcat $TAIRGOURLNAME > ATH_GO_GOSLIM1.txt
      #cp $TAIRGOURLNAME ATH_GO_GOSLIM1.txt
      sed -e "1,4d" ATH_GO_GOSLIM1.txt > ATH_GO_GOSLIM.txt
      sed -e "1d" $TAIRAGURLNAME > affy_AG_array_elements1.txt
      sed -e "1d" $TAIRATHURLNAME > affy_ATH1_array_elements1.txt
      ## Starting with Spring 2021 download, this file has NULL where
      ## there used to be spaces so we remove them here as well
      zcat $TAIRPMIDURLNAME | sed -e "1d" | sed -e 's/NULL//g' > LocusPublished1.txt
      sed -e "1d" $TAIRGENEURLNAME > TAIR_sequenced_genes1
      
      iconv -f WINDOWS-1252 -t UTF-8 TAIR_sequenced_genes1 > TAIR_sequenced_genes2 
      ## get rid of quotes
      sed -i -e 's/"//g' TAIR_sequenced_genes2
      # gene_aliases has various number of columns (some lines 2, others 4)
      zcat $TAIRSYMBOLURLNAME | awk '{print $1 "\t" $2}' > gene_aliases1
      
      cp $TAIRPATHURLNAME  aracyc_dump1
      tail -n +2 aracyc_dump1 > aracyc_dump2
      mv aracyc_dump2 aracyc_dump1
    else
      echo "the latest $TAIRSOURCENAME data is still $TAIRSOURCEDATE"
fi
