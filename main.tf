data "template_file" "_log_configuration" {
  count = "${var.log_driver == "__NOT_DEFINED__" ? 0 : 1}"
  #  depends_on = ["data.template_file._log_driver_options"]
  template = <<JSON
$${ jsonencode("logConfiguration") } : {
$${ jsonencode("logDriver") } : $${ jsonencode(log_driver) },
$${ jsonencode("options") } : {
$${ log_driver_options }
}
}
JSON
  vars {
    log_driver = "${var.log_driver}"
    log_driver_options = "${join(",\n", data.template_file._log_driver_options.*.rendered)}"
  }
}

data "template_file" "_log_driver_options" {
  count = "${ length(keys(var.log_driver_options)) }"
  template = <<JSON
$${ jsonencode(key) }: $${ jsonencode(value)}
JSON

  vars {
    key = "${ element(keys(var.log_driver_options), count.index) }"
    value = "${ lookup(var.log_driver_options, element(keys(var.log_driver_options), count.index)) }"
  }
}


data "template_file" "_port_mappings" {
  #  depends_on = ["data.template_file._port_mapping"]
  template = <<JSON
$${val}
JSON
  #host_port == "__NOT_DEFINED__" && container_port == "__NOT_DEFINED__" && protocol == "__NOT_DEFINED__" ? $${ jsonencode([])} : $${val}
  vars {
    val = "${join(",\n", data.template_file._port_mapping.*.rendered)}"
    host_port = "${ lookup(var.port_mappings[0], "hostPort", "") }"
    container_port = "${ lookup(var.port_mappings[0], "containerPort") }"
    protocol = "${ lookup(var.port_mappings[0], "protocol", "") }"
  }
}

data "template_file" "_port_mapping" {
  count = "${ lookup(var.port_mappings[0], "containerPort") == "__NOT_DEFINED__" ? 0 : length(var.port_mappings) }"
  template = <<JSON
{
$${join(",\n",
  compact(
    list(
    host_port == "" || host_port == "__NOT_DEFINED_" ? "" : "$${ jsonencode("hostPort") }: $${host_port}",
    container_port == "" || container_port == "__NOT_DEFINED_" ? "" : "$${jsonencode("containerPort")}: $${container_port}",
    protocol == "" || protocol == "__NOT_DEFINED_" ? "" : "$${ jsonencode("protocol") }: $${jsonencode(protocol)}"
    )
  )
)}
}
JSON
  vars {
    host_port = "${ lookup(var.port_mappings[count.index], "hostPort", "") }"
    container_port = "${ lookup(var.port_mappings[count.index], "containerPort") }"
    protocol = "${ lookup(var.port_mappings[count.index], "protocol", "") }"
  }
}
data "template_file" "_environment_vars" {
  count = "${lookup(var.environment_vars, "__NOT_DEFINED__", "__ITS_DEFINED__") == "__NOT_DEFINED__" ? 0 : 1}"
  depends_on = [
    "data.template_file._environment_var"]
  template = <<JSON
$${ jsonencode("environment") } : [
$${val}
]
JSON
  vars {
    val = "${join(",\n", data.template_file._environment_var.*.rendered)}"
  }
}

data "template_file" "_environment_var" {
  count = "${ length(keys(var.environment_vars)) }"
  template = <<JSON
{
$${join(",\n",
  compact(
    list(
    var_name == "__NOT_DEFINED__" ? "" : "$${ jsonencode("name") }: $${ jsonencode(var_name)}",
    var_value == "__NOT_DEFINED__" ? "" : "$${ jsonencode("value") }: $${ jsonencode(var_value)}"
    )
  )
)}
}
JSON

  vars {
    var_name = "${ element(sort(keys(var.environment_vars)), count.index) }"
    var_value = "${  lookup(var.environment_vars, element(sort(keys(var.environment_vars)), count.index), "") }"
  }
}

data "template_file" "_final" {
  depends_on = [
    "data.template_file._environment_vars",
    "data.template_file._port_mappings",
    "data.template_file._log_configuration",
  ]
  template = <<JSON
[{
  $${val}
}]
JSON
  vars {
    val = "${join(",\n    ",
      compact(list(
        "${jsonencode("cpu")}: ${var.cpu}",
        "${jsonencode("memory")}: ${var.memory}",
        "${jsonencode("entryPoint")}: ${jsonencode(compact(split(" ", var.entrypoint)))}",
        "${jsonencode("command")}: ${jsonencode(compact(split(" ", var.service_command)))}",
        "${jsonencode("links")}: ${jsonencode(var.links)}",
        "${jsonencode("portMappings")}: [${data.template_file._port_mappings.rendered}]",
        "${join("", data.template_file._environment_vars.*.rendered)}",
        "${join("", data.template_file._log_configuration.*.rendered)}",
        "${jsonencode("name")}: ${jsonencode(var.service_name)}",
        "${jsonencode("image")}: ${jsonencode(var.service_image)}",
        "${jsonencode("essential")}: ${var.essential ? true : false }"
        ))
    )}"
  }
}
