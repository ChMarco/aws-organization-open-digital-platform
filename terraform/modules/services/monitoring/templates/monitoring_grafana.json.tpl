[
  {
    "name": "grafana",
    "image": "grafana/grafana",
    "cpu": 256,
    "memory": 512,
    "environment": [
      {
        "Name": "GF_SECURITY_ADMIN_USER",
        "Value": "admin"
      },
      {
        "Name": "GF_SECURITY_ADMIN_PASSWORD",
        "Value": "changeme"
      },
      {
        "Name": "GF_USERS_ALLOW_SIGN_UP",
        "Value": "true"
      }
    ],
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ],
    "essential": true,
    "privileged": true,
    "mountPoints": [
      {
        "sourceVolume": "efs-monitoring",
        "containerPath": "/var/lib/grafana"
      }
    ],
    "dockerLabels": {
        "org.label-schema.group": "monitoring"
    }
  }
]
