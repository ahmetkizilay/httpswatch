#!bin/bash

SITE=$1
TODAY=$2

HTTPS_FILE_NAME="./"$TODAY"/https-"$SITE

cat $HTTPS_FILE_NAME | grep -i "^*  SSL certificate verify ok." | wc -l