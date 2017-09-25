[
  {
    "name": "vault-server",
    "image": "vault",
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
        "name": "VAULT_LOCAL_CONFIG",
        "value": "{\"listener\":{ \"tcp\":{ \"address\": \"0.0.0.0:8200\", \"tls_disable\": \"1\" }}, \"backend\": {\"consul\": {\"path\": \"vault/\", \"address\": \"127.0.0.1:8500\", \"scheme\": \"http\", \"token\": \"04AEB3B2-45BD-4FCE-9137-ED54BD44023B\", \"advertise_addr\": \"http://127.0.0.1:8200\"}}, \"default_lease_ttl\": \"168h\",\"max_lease_ttl\": \"720h\", \"disable_mlock\": true}"
      },
      {
        "name": "VAULT_ADDR",
        "value": "http://127.0.0.1:8200"
      }
    ],
    "mountPoints": [
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