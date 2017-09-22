[
  {
    "name": "nodeexporter",
    "image": "prom/node-exporter",
    "cpu": 0,
    "privileged": null,
    "memoryReservation": 150,
    "portMappings": [
      {
        "containerPort": 9100,
        "hostPort": 9100,
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "privileged": true
  }
]