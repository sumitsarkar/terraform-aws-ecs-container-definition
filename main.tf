provider "aws" {
  region = "${var.region}"
}

resource "aws_ecs_task_definition" "service" {
  family = "${var.service_name}-${var.environment}"
  container_definitions = "${data.template_file._final.rendered}"
  # This module only supports "bridge" mode for now.
  # ToDo: Support awsvpc mode for Fargate tasks.
  network_mode = "bridge"
  task_role_arn = "${var.task_role_arn}"
}