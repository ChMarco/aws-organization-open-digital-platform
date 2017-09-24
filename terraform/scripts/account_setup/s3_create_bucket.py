#!/usr/bin/env python

"""Terraform S3 Create Buckets.

Usage:
  s3_create_buckets.py -h
  s3_create_buckets.py <aws_account_id>

Options:
  -h --help         Show this screen
  aws_account_id    : Account ID to create bucket in
"""

import botocore
from docopt import docopt
from utils import assume_role


def create_s3_bucket(account_id):
    session_prefix = 'tf_assume'

    assume_session = assume_role(account_id, session_prefix)

    session = assume_session()
    s3 = session.client('s3')
    s3_resource = session.resource('s3')

    folders = [
        'terraform-codebuild',
        'terraform-efs-backup',
        'terraform-scripts',
        'terraform-scripts/jenkins',
        'terraform-state',
        'terraform-outputs'
    ]

    account_bucket = '{}-infrastructure-terraform'.format(account_id)
    bucket = s3_resource.Bucket(account_bucket)

    print("\nCreating bucket {} in account {}\n".format(account_bucket, account_id))
    try:
        s3_resource.meta.client.head_bucket(Bucket=account_bucket)
        print("\nBucket already exists.. skipping\n")
    except botocore.exceptions.ClientError as e:
        error_code = int(e.response['Error']['Code'])
        if error_code == 404:
            response = s3.create_bucket(
                Bucket=account_bucket,
                CreateBucketConfiguration={
                    'LocationConstraint': 'eu-west-1'
                }
            )
            print("\nBucket created and accessible at - {}\n".format(response['Location']))

    print("\nEnabling versioning..\n")
    s3.put_bucket_versioning(
        Bucket=account_bucket,
        VersioningConfiguration={
            'Status': 'Enabled'
        }
    )
    print("\nCreating default folders - " + ', '.join(folders) + "\n")
    for folder in folders:
        bucket.put_object(
            Body='',
            Key='{}/'.format(folder)
        )
    print("Bucket and folders successfully created\n")


def main(args):
    create_s3_bucket(args["<aws_account_id>"])


if __name__ == "__main__":
    arguments = docopt(__doc__, version='0.0.1rc')
    main(arguments)
