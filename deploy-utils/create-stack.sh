#!/bin/bash

STACK_NAME=$1

if [ "$STACK_NAME" == "" ]; then
  echo "Enter Stack Name"
  exit -1
fi

PROFILE=${2:-"personal"}

BUCKET=codebase-httpswatch
TEMPLATE_BODY=file://$PWD/deploy-utils/cfn-template.json
PARAMETERS_URL=file://$PWD/build/cfn-parameters.json

COMMAND="aws --profile ${PROFILE} \
  cloudformation create-stack \
    --stack-name ${STACK_NAME} \
    --template-body $TEMPLATE_BODY \
    --parameters $PARAMETERS_URL \
    --capabilities CAPABILITY_IAM"

WAIT_COMMAND="aws --profile ${PROFILE} \
  cloudformation wait \
    stack-create-complete --stack-name ${STACK_NAME}"

echo $COMMAND

read -p "Do you want to continue (y/n)? " -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

$COMMAND

echo "waiting for stack to be ready..."
${WAIT_COMMAND}