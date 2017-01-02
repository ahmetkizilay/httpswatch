#!/bin/bash

TODAY=$(date +%Y-%m-%d)

bash ./download-all.sh input.txt $TODAY

bash ./run.sh input.txt $TODAY > /tmp/${TODAY}.tsv

rm -f /tmp/$TODAY.tar.gz && cd /tmp/$TODAY && tar -czf /tmp/$TODAY.tar.gz *

echo $TODAY