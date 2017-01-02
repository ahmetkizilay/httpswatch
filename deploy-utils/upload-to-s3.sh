#!/bin/bash

VERSION=$(node -e "console.log(require('./package.json').version);")

PROFILE=${1:-"personal"}

aws --profile $PROFILE \
  s3 cp ./build/${VERSION}.zip s3://codebase-httpswatch/