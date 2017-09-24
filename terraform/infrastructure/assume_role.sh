#! /bin/bash
#
# Dependencies:
#   brew install jq
#
# Example:
#   source assume_role
#   alias assume_role="source assume_role"
#
# Notes:
#   Remove .sh file extension and move file to a location available to your $PATH
#   chmod +x <file>

unset AWS_SESSION_TOKEN

aws_assume_account=${1}
aws_profile=${2}
aws_assume_role=${4:-ManagementAccountAccessRole}
aws_assume_session=${5:-tf_assume}

# Note: ${var} instead of $var avoids bug with substitution deleting characters
echo "arn:aws:iam::${aws_assume_account}:role/${aws_assume_role}"

temp_role=$(aws sts assume-role \
                    --profile "${aws_profile}" \
                    --role-arn "arn:aws:iam::${aws_assume_account}:role/${aws_assume_role}" \
                    --role-session-name "${aws_assume_session}")

echo $aws_assume_account
echo $aws_assume_role
echo $aws_assume_session

# Note: xargs strips the containing quotes which is essential for the export to work
export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId | xargs)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey | xargs)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken | xargs)

env | grep -i AWS_