#!/bin/bash

INPUT_DIR="/Users/nardini/DataHDD/Downloads/eCloud/dataset-round1/15-11-18_11:22:04"
DEST_FILE="uploaded_records.txt"

PROVIDER_ID="NAME-HERE"
USER="USER"
PASS="PASS"

while read FILE_NAME
do
    RECORD=$INPUT_DIR/$FILE_NAME

    # generate eCloud ID
    RESPONSE=`curl -X POST --user $USER:$PASS -i http://iks-kbase.synat.pcss.pl/api/cloudIds?providerId=${PROVIDER_ID}\&recordId=${FILE_NAME} 2>/dev/null`;
    URL_REPRESENTATION=`echo ${RESPONSE} | python ./extractECloudIDs.py`;
    #echo "REPRESENTATION: $URL_REPRESENTATION"
    #echo "$RESPONSE"

    # creating new representation
    RESPONSE=`curl -X POST "Accept: application/json" --user $USER:$PASS -H "Content-Type: application/x-www-form-urlencoded" -d "providerId=${PROVIDER_ID}" -i ${URL_REPRESENTATION} 2> /dev/null`;
    LOCATION=`echo "${RESPONSE}" | grep "^Location:" | python ./extractRepresentations.py`;
    #echo "LOCATION: $LOCATION"
    #echo "$RESPONSE"

    # loading content to a new version
    RESPONSE=`curl -X POST --user $USER:$PASS -H "Content-Type: multipart/form-data" -F "mimeType=application/xml" -F "data=@${RECORD}" -i ${LOCATION}/files 2> /dev/null`;
    FINAL_URL=`echo "${RESPONSE}" | grep "^Location:" | python ./extractRepresentations.py`;
    echo $FINAL_URL >> $DEST_FILE
    #echo "$RESPONSE"
done < $1
