output "task_definition_arn" {
  value = "${aws_ecs_task_definition.service.arn}"
}

output "task_definition_family" {
  value = "${aws_ecs_task_definition.service.family}"
}

output "task_definition_revision" {
  value = "${aws_ecs_task_definition.service.revision}"
}