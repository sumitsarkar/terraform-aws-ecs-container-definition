variable "service_name" {
  default = "Name of the service."
}

variable "service_image" {
  description = "URL to the service image. Currently only Docker Hub an ECR are supported."
}

variable "cpu" {
  description = "Number of CPU units to assign to this task."
}

variable "memory" {
  description = "Memory in MegaBytes to assign to this task."
}

variable "log_driver" {
  default = "awslogs"
}

variable "log_driver_options" {
  type = map(string)
  default = {
    "awslogs-group"         = "common-log-group"
    "awslogs-region"        = "eu-west-1"
    "awslogs-stream-prefix" = "container"
  }
}

variable "port_mappings" {
  type = list(object({
    hostPort = string
    containerPort = string
  }))
  default = [
    {
      hostPort      = "__NOT_DEFINED__"
      containerPort = "__NOT_DEFINED__"
    },
  ]
}

variable "links" {
  type    = list(string)
  default = []
}

variable "essential" {
  default = true
}

variable "entrypoint" {
  default = ""
}

variable "service_command" {
  default     = ""
  description = "The command that needs to run at startup of the task."
}

variable "environment_vars" {
  type = map(string)
}

