[
  {
    "name": "vault-server",
    "image": "${account_id}.dkr.ecr.eu-west-1.amazonaws.com/vault:${vault_image_tag}",
    "memory": 128,
    "cpu": 64,
    "essential": true,
    "portMappings": [
      {
        "hostPort": 8200,
        "containerPort": 8200,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "VAULT_ADDR",
        "value": "http://127.0.0.1:8200"
      }
    ],
    "mountPoints": [
      {
        "containerPath": "/vault/config",
        "sourceVolume": "vault_config"
      },
      {
        "containerPath": "/policies",
        "sourceVolume": "vault_policies"
      }
    ],
    "command": [
        "server"
    ]
  }
]