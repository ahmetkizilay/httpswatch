#!/bin/bash

SITE=$1
TODAY=$2

HTTPS_FILE_NAME="/tmp/"$TODAY"/https-"$SITE

cat $HTTPS_FILE_NAME | grep -i "^< HTTP/1.1 2" | wc -l