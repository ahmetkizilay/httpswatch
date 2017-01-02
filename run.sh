#!/bin/bash

INPUT_FILE=${1:-"input.txt"}

TODAY=$2
if [ "$TODAY" == "" ]; then
  TODAY=$(date +%Y-%m-%d)
fi


echo -e 'NAME\tVALID SSL\tHTTPS AVAILABLE\tDEFAULTS TO HTTPS\tHSTS ENABLED\tHSTS INCLUDES SUBDOMAINS\tHSTS MAX AGE LONG ENOUGH\tHTSH PRELOAD'
while IFS='' read -r line || [[ -n "$line" ]]; do
  /bin/bash ./test.sh $line $TODAY
done < "$INPUT_FILE"
