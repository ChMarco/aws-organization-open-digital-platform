#! /bin/bash

mkdir -p ~/.aws

echo "
[default]
aws_access_key_id: ${1}
aws_secret_access_key: ${2}
" >> ~/.aws/test-credentials