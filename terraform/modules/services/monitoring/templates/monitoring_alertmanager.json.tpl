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
      "-config.file=/etc/alertmanager/alertmanager.yml",
      "-storage.path=/alertmanager"
    ],
    "mountPoints": [
      {
        "sourceVolume": "alertmanager_data",
        "containerPath": "/alertmanager"
      },
      {
        "sourceVolume": "alertmanager_config",
        "containerPath": "/etc/alertmanager"
      }
    ],
    "dockerLabels": {
        "org.label-schema.group": "monitoring"
    }
  }
]