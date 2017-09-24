[
  {
    "name": "jenkins",
    "image": "633665859024.dkr.ecr.eu-west-1.amazonaws.com/jenkins:${jenkins_image_tag}",
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
        "sourceVolume": "jenkins_data",
        "containerPath": "/var/jenkins_home"
      }
    ]
  }
]