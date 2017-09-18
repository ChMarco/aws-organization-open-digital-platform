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
      "-alertmanager.url=http://${monitoring_elb_dns_name}:9093",
      "-storage.local.memory-chunks=300000",
      "-storage.local.retention=744h"
    ],
    "dockerLabels": {
        "org.label-schema.group": "monitoring"
    }
  }
]