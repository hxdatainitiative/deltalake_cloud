resource "aws_glue_job" "glue_job" {
  count             = var.create_job ? 1 : 0
  name              = var.name
  description       = var.description
  role_arn          = aws_iam_role.glue_role.arn
  glue_version      = var.glue_version
  timeout           = var.timeout
  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers
  #   connections       = var.glue_connection_names

  command {
    python_version  = 3
    script_location = var.script_location
  }

  execution_property {
    max_concurrent_runs = var.max_concurrent_runs
  }

  default_arguments = tomap(jsondecode(var.runtime_arguments))
}

resource "aws_cloudwatch_log_group" "glue_log_group" {
  name = "/aws/glue/${var.name}/output"
}
