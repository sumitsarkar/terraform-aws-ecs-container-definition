provider "aws" {
  region = "${var.region}"
}

data "template_file" "service" {
  template = "${file("${path.module}/container-definitions/service.json.tpl")}"

  vars {
    name = "${var.service_name}"
    image = "${var.service_image}"
    command = "${jsonencode(var.service_command)}"
    port = "${var.service_port}"
    region = "${var.region}"
    log_group = "${var.log_group}"
    command = "null"
    memory = "${var.memory}"
    cpu = "${var.cpu}"
  }
}

resource "aws_ecs_task_definition" "service" {
  family = "${var.service_name}-${var.environment}"
  container_definitions = "${data.template_file.service.rendered}"
  # This module only supports "bridge" mode for now.
  # ToDo: Support awsvpc mode for Fargate tasks.
  network_mode = "bridge"
  task_role_arn = "${var.task_role_arn}"
}