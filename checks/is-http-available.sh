#!/bin/bash

SITE=$1
TODAY=$2

HTTP_FILE_NAME="/tmp/"$TODAY"/http-"$SITE

cat $HTTP_FILE_NAME | grep -i "^< HTTP/1.1 2" | wc -l