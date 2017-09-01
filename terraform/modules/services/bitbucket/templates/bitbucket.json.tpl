[
  {
    "name": "bitbucket",
    "image": "atlassian/bitbucket-server",
    "cpu": 512,
    "memory": 2048,
    "essential": true,
    "environment": [
      {
        "Name": "ELASTICSEARCH_ENABLED",
        "Value": "true"
      },
      {
        "Name": "APPLICATION_MODE",
        "Value": "default"
      },
      {
        "Name": "HAZELCAST_NETWORK_MULTICAST",
        "Value": "true"
      }
    ],
    "portMappings": [
      {
        "containerPort": 7990,
        "hostPort": 7990
      },
      {
        "containerPort": 7999,
        "hostPort": 7999
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "efs-bitbucket",
        "containerPath": "/var/atlassian/application-data/bitbucket"
      }
    ]
  }
]