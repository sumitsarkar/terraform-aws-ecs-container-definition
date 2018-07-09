variable "region" {
  default = "eu-west-1"
  description = "AWS Region"
}
variable "environment" {
  description = "Name of the environment to launch in. Used mainly for naming."
}
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
variable "log_group" {
  description = "Name of the Cloudwatch log group to which tasks will write logs to."
}

variable "log_driver" {
  default = "awslogs"
}
variable "log_driver_options" {
  type = "map"
  default = {
    "awslogs-group" = "common-log-group"
    "awslogs-region"= "eu-west-1",
    "awslogs-stream-prefix"= "container"
  }
}

variable "port_mappings" {
  type = "list"
  default = [
    {
      "hostPort" = "__NOT_DEFINED__",
      "containerPort" = "__NOT_DEFINED__"
    }
  ]
}

variable "links" {
  type = "list"
  default = []
}
variable "essential" {
  default = true
}
variable "entrypoint" {
  default = ""
}


variable "service_command" {
  default = ""
  description = "The command that needs to run at startup of the task."
}
variable "task_role_arn" {
  default = "ARN of the role that the task should run with."
}
variable "environment_vars" {
  type = "map"
  default = {
    "__NOT_DEFINED__" = "__NOT_DEFINED__"
  }
}