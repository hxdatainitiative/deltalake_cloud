module "test_job" {
  source = "../modules/glue"

  name                = "${local.project_name}-sample-job"
  description         = "Sample glue job to use"
  glue_version        = "4.0"
  timeout             = 600
  worker_type         = "Standard"
  number_of_workers   = 2
  connections         = ""
  python_version      = 3
  script_location     = ""
  max_concurrent_runs = 1
  runtime_arguments = jsonencode({
    "--account-id" : "asd123",
    "--short-env" : "dev"
    }
  )
}
