#!/bin/bash

SITE=$1
TODAY=$2

HTTP_FILE_NAME="./"$TODAY"/http-"$SITE

REDIRECTS_HTTP=$(cat $HTTP_FILE_NAME | grep -i "^< HTTP/1.1 3" | wc -l)
if [ $REDIRECTS_HTTP -gt 0 ]; then
  cat $HTTP_FILE_NAME | grep -i "^< Location: https:\/\/" | wc -l
else
  echo 0
fi