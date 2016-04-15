#!/bin/bash

INPUT_DIR=""
PROVIDER_ID="NAME-HERE"
DATASET_ID="NAME-HERE"

URL="http://iks-kbase.synat.pcss.pl/api/data-providers/${PROVIDER_ID}/data-sets/${DATASET_ID}/assignments"
USER="USER"
PASS="PASS"

while read RECORD_URI
do

    # extracting data from RECORD URI
    ECLOUD_ID=`echo $RECORD_URI | cut -c 44-`
    ECLOUD_ID=`echo $ECLOUD_ID | rev | cut -c 110- | rev`
    #echo $ECLOUD_ID

    REPRESENTATION_NAME="XML"

    VERSION=`echo $RECORD_URI | cut -c 126-`
    VERSION=`echo $VERSION | rev | cut -c 44- | rev`
    #echo $VERSION

    STRING="cloudId=${ECLOUD_ID}&representationName=${REPRESENTATION_NAME}&version=${VERSION}"
    #echo "---> " $STRING

    # assigning each record to dataset
    RESPONSE=`curl -X POST --user $USER:$PASS -H "Content-Type: application/x-www-form-urlencoded" -d "${STRING}" -i $URL 2> /dev/null`
    #echo "$RESPONSE"

    STATUS=`echo "$RESPONSE" | grep ^HTTP | cut -d' ' -f2`
    #echo $STATUS
    echo -e $STRING"\t"$STATUS
done < $1

exit 0
