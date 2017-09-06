[
  {
    "name": "jenkins",
    "image": "633665859024.dkr.ecr.eu-west-1.amazonaws.com/jenkins:5d59ca03-4095-41e9-87f0-e701f0344581",
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