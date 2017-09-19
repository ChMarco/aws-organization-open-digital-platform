[
  {
    "name": "linkerd",
    "image": "docker.io/buoyantio/linkerd:1.2.0",
    "command": [
      "-log.level=DEBUG",
      "-com.twitter.finagle.tracing.debugTrace=true",
      "/etc/linkerd/linkerd.yaml"
    ],
    "memory": 1024,
    "portMappings": [
      {
        "hostPort": 4140,
        "containerPort": 4140,
        "protocol": "tcp"
      },
      {
        "hostPort": 4141,
        "containerPort": 4141,
        "protocol": "tcp"
      },
      {
        "hostPort": 9990,
        "containerPort": 9990,
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "mountPoints": [
      {
        "containerPath": "/etc/linkerd",
        "sourceVolume": "linkerd_config",
        "readOnly": true
      }
    ],
    "environment": [
      {
        "name": "SERVICE_9990_NAME",
        "value": "linkerd"
      }
    ]
  }
]