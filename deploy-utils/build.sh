#!/bin/bash

VERSION=$(node -e "console.log(require('./package.json').version);")

mkdir ./build

zip -r ./build/${VERSION}.zip . -x *.git* ./node_modules/aws-sdk/\* ./build/\* ./deploy-utils/\* ./securethenews/\*
