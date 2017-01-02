#!/bin/bash

VERSION=$(node -e "console.log(require('./package.json').version);")

cat ./deploy-utils/cfn-parameters.json.template | sed 's/{{AppVersion}}/'${VERSION}'/' > ./build/cfn-parameters.json