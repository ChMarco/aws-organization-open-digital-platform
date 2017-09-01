[
  {
    "name": "nginx",
    "image": "nginx",
    "cpu": 256,
    "memory": 256,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "nginx-conf",
        "containerPath": "/etc/nginx/nginx.conf",
        "readOnly": true
      }
    ]
  }
]