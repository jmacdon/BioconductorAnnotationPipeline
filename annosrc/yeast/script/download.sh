#!/bin/sh
set -e
. ./env.sh

BASE_URL=$YGSOURCEURL
THIS_YEAR=`date|awk '{print $6}'`
LATEST_DATE=`curl --fail -IL $BASE_URL/curation/literature/gene2pmid.tab | grep "Last-Modified" | awk '{print $5 "-" $4 $3}'`
## The domains.tab file is no longer generated as of 2021. It may be possible to generate on the fly from YeastMine at
## https://yeastmine.yeastgenome.org/yeastmine/template.do?name=Domains_Tab but it doesn't include the
## InterPro ID
## for now we just get the last good one from them
YG_URL=$BASE_URL/curation/calculated_protein_info/domains/archive
REJECTORF_URL=ftp://ftp.broadinstitute.org/pub/annotation/fungi/comp_yeasts/S6.RFC_test/a.orf_decisions.txt
## REJECTORF_URL=https://compbio.mit.edu/4yeasts/S6.RFC_test/a.orf_decisions.txt 

if [ -z "$LATEST_DATE" ]; then
       echo "${LATEST_DATA}"
       exit 1
fi

if [ "$LATEST_DATE" != "$YGSOURCEDATE" ]; then
      echo "update $YGSOURCENAME data from $YGSOURCEDATE to $LATEST_DATE"
      sed -i -e "s/ YGSOURCEDATE=.*$/ YGSOURCEDATE=$LATEST_DATE/g" env.sh    
      mkdir -p ../$LATEST_DATE
      cd ../$LATEST_DATE
      curl --fail --disable-epsv -O $YG_URL/domains_201610.tab.gz
      curl --fail --disable-epsv -O $BASE_URL/curation/literature/gene_literature.tab
      curl --fail --disable-epsv -O $BASE_URL/curation/literature/gene_association.sgd.gaf.gz
      curl --fail --disable-epsv -O $BASE_URL/curation/chromosomal_feature/SGD_features.tab
      ## And don't run this line
      ##curl --fail --disable-epsv -O $YG_URL
      curl --fail -O $REJECTORF_URL
      cd ../script  
      #sh getsrc.sh
else
      echo "the latest $YGSOURCENAME data is still $YGSOURCEDATE"
fi
