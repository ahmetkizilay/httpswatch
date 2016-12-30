#!/bin/bash

SITE=$1
TODAY=$2

HTTP_URL="http://"$SITE
HTTPS_URL="https://"$SITE

HTTP_FILE_NAME=$TODAY"/http-"$SITE
HTTPS_FILE_NAME=$TODAY"/https-"$SITE

curl --verbose -s -o /dev/null --max-time 5 $HTTPS_URL > $HTTPS_FILE_NAME 2> $HTTPS_FILE_NAME
curl --verbose -s -o /dev/null --max-time 5 $HTTP_URL > $HTTP_FILE_NAME 2> $HTTP_FILE_NAME