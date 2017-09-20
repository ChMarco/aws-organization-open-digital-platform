[
  {
    "name": "efs-backup",
    "image": "vidazoohub/aws-efs-backup",
    "cpu": 10,
    "memory": 512,
    "essential": true,
    "privileged": true,
    "environment": [
      {
        "name": "EFS_ID",
        "value": "${efs_id}"
      },
      {
        "name": "EFS_NAME",
        "value": "${efs_name}"
      },
      {
        "name": "AWS_ACCESS_KEY_ID",
        "value": "${access_key}"
      },
      {
        "name": "AWS_SECRET_ACCESS_KEY",
        "value": "${secret_key}"
      },
      {
        "name": "AWS_DEFAULT_REGION",
        "value": "${aws_region}"
      },
      {
        "name": "S3_BUCKET",
        "value": "${backup_bucket}"
      }
    ]
  }
]