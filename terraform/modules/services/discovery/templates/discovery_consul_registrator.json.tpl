[
  {
    "name": "consul-registrator",
    "image": "gliderlabs/registrator:v7",
    "memory": 16,
    "cpu": 10,
    "essential": true,
    "entryPoint": [
      "/bin/consul-registrator/start.sh"
    ],
    "mountPoints": [
      {
        "containerPath": "/bin/consul-registrator",
        "sourceVolume": "consul_registrator_bin",
        "readOnly": true
      },
      {
        "containerPath": "/tmp/docker.sock",
        "sourceVolume": "docker_socket",
        "readOnly": true
      }
    ]
  }
]