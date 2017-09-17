[
  {
    "name": "cadvisor",
    "image": "google/cadvisor:latest",
    "cpu": 10,
    "memory": 300,
    "portMappings": [
      {
        "containerPort": 9191,
        "hostPort": 9191
      }
    ],
    "essential": true,
    "privileged": true,
    "mountPoints": [
      {
        "sourceVolume": "root",
        "containerPath": "/rootfs",
        "readOnly": true
      },
      {
        "sourceVolume": "var_run",
        "containerPath": "/var/run",
        "readOnly": false
      },
      {
        "sourceVolume": "sys",
        "containerPath": "/sys",
        "readOnly": true
      },
      {
        "sourceVolume": "var_lib_docker",
        "containerPath": "/var/lib/docker",
        "readOnly": true
      },
      {
        "sourceVolume": "cgroup",
        "containerPath": "/cgroup",
        "readOnly": true
      }
    ],
    "dockerLabels": {
        "org.label-schema.group": "monitoring"
    }
  }
]