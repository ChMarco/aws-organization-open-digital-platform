[
  {
    "name": "gocd",
    "image": "gocd/gocd-server",
    "cpu": 512,
    "memory": 1024,
    "essential": true,
    "environment": [
      {
        "Name": "JAVA_OPTS",
        "Value": "-Djenkins.install.runSetupWizard=false"
      }
    ],
    "portMappings": [
      {
        "containerPort": 8153,
        "hostPort": 8153
      },
      {
        "containerPort": 8154,
        "hostPort": 8154
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "gocd_data",
        "containerPath": "/godata"
      },
      {
        "sourceVolume": "gocd_data",
        "containerPath": "/godata"
      },
      {
        "sourceVolume": "gocd_data",
        "containerPath": "/godata"
      }
    ]
  }
]