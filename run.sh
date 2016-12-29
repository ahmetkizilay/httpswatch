#!/bin/bash

TODAY=$(date +%Y-%m-%d)
rm -rf $TODAY && mkdir $TODAY

while IFS='' read -r line || [[ -n "$line" ]]; do
  /bin/bash ./test.sh $line $TODAY
done < "$1"
