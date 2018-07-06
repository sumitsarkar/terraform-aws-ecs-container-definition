[
  {
    "name": "${name}",
    "image": "${image}",
    "memory": ${memory},
    "cpu": ${cpu},
    "essential": true,
    "command": ${command},
    "portMappings": [
      {
        "containerPort": ${port},
        "hostPort": 0
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "container"
      }
    }
  }
]