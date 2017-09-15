[
  {
    "name": "alertmanager",
    "image": "prom/alertmanager",
    "cpu": 10,
    "memory": 300,
    "portMappings": [
      {
        "containerPort": 9093,
        "hostPort": 9093
      }
    ],
    "essential": true,
    "privileged": true,
    "command": [
      "-config.file=/etc/alertmanager/config.yml",
      "-storage.path=/alertmanager"
    ],
    "mountPoints": [
      {
        "sourceVolume": "efs-monitoring",
        "containerPath": "/alertmanager"
      },
      {
        "sourceVolume": "efs-monitoring",
        "containerPath": "/etc/alertmanager"
      }
    ],
    "dockerLabels": {
        "org.label-schema.group": "monitoring"
    }
  }
]