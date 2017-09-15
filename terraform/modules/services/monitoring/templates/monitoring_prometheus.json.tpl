[
  {
    "name": "prometheus",
    "image": "prom/prometheus",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "privileged": true,
    "portMappings": [
      {
        "containerPort": 9090,
        "hostPort": 9090
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "prometheus_data",
        "containerPath": "/prometheus"
      },
      {
        "sourceVolume": "efs-monitoring",
        "containerPath": "/etc/prometheus"
      }
    ],
    "command": [
      "-config.file=/etc/prometheus/prometheus.yml",
      "-storage.local.path=/prometheus",
      "-alertmanager.url=http://alertmanager:9093",
      "-storage.local.memory-chunks=100000"
    ],
    "dockerLabels": {
        "org.label-schema.group": "monitoring"
    }
  }
]