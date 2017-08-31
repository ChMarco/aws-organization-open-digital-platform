[
  {
    "name": "jenkins",
    "image": "jenkins",
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
        "containerPort": 8080,
        "hostPort": 8080
      },
      {
        "containerPort": 50000,
        "hostPort": 50000
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "efs-jenkins",
        "containerPath": "/var/jenkins_home"
      }
    ]
  }
]