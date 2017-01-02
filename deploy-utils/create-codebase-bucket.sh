#!/bin/bash

PROFILE=${1:-"personal"}
aws --profile $PROFILE \
  s3 mb s3://codebase-httpswatch
