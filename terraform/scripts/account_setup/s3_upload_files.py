#!/usr/bin/env python

"""Terraform S3 Upload Files.

Usage:
  s3_upload_files.py -h
  s3_upload_files.py <aws_account_id> <local_directory> <s3_directory>

Options:
  -h --help         Show this screen
  aws_account_id    : Account ID to create bucket in
  local_directory   : Directory containing files to be uploaded
  s3_directory      : Directory to upload files in S3
"""

import botocore
import os
from docopt import docopt
from utils import assume_role


def upload_s3_folders(account_id, local_directory, s3_directory):
    session_prefix = 'tf_assume'
    assume_session = assume_role(account_id, session_prefix)

    session = assume_session()
    s3 = session.client('s3')
    s3_resource = session.resource('s3')
    account_bucket = "{}-infrastructure-terraform".format(account_id)

    try:
        s3_resource.meta.client.head_bucket(Bucket=account_bucket)
        print("\nBucket exists.. uploading files\n")
        for root, dirs, files in os.walk(local_directory):
            for filename in files:
                local_path = os.path.join(root, filename)
                relative_path = os.path.relpath(local_path, local_directory)
                s3_path = os.path.join(s3_directory, relative_path)
                try:
                    s3.head_object(Bucket=account_bucket, Key=s3_path)
                    print('\nPath found on S3! Skipping {}...'.format(s3_path))
                except botocore.exceptions.ClientError as ex:
                    if ex.response['Error']['Code'] == '404':
                        print('\nUploading {}...'.format(s3_path))
                        s3.upload_file(local_path, account_bucket, s3_path)
        print("\nFiles successfully uploaded\n")
    except botocore.exceptions.ClientError as e:
        error_code = int(e.response['Error']['Code'])
        if error_code == 404:
            print("Bucket doesn't exist\n")
            print("Run s3_create_bucket.py\n")


def main(args):
    upload_s3_folders(args["<aws_account_id>"], args["<local_directory>"], args["<s3_directory>"])


if __name__ == "__main__":
    arguments = docopt(__doc__, version='0.0.1rc')
    main(arguments)
