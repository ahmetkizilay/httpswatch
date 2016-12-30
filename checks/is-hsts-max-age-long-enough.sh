#/bin/bash

SITE=$1
TODAY=$2
COMPARE_AGE=${3:-10886400}

HTTPS_FILE_NAME="./"$TODAY"/https-"$SITE

MAX_AGE=$(cat $HTTPS_FILE_NAME | grep -i "^< Strict-Transport-Security: " | grep -ioh "max-age=[0-9]*" | sed 's/max-age=//')

if ! [ "$MAX_AGE" == "" ] && [ $MAX_AGE -ge $COMPARE_AGE ]; then
  echo 1
else
  echo 0
fi
