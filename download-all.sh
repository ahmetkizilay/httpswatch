#!/bin/bash

INPUT_FILE=${1:-"input.txt"}

TODAY=$(date +%Y-%m-%d)
rm -rf /tmp/$TODAY && mkdir /tmp/$TODAY

while IFS='' read -r line || [[ -n "$line" ]]; do
  /bin/bash ./download.sh $line $TODAY
done < "$INPUT_FILE"
