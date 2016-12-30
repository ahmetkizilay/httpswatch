#!/bin/bash

TODAY=$(date +%Y-%m-%d)

echo -e "VALID_SSL\tHTTP_AVAILABLE\t"
while IFS='' read -r line || [[ -n "$line" ]]; do
  /bin/bash ./test.sh $line $TODAY
done < "$1"
