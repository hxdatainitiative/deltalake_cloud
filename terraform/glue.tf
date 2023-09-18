module "test_job" {
  source = "../modules/glue"

  name                = "${local.project_name}-write-job"
  description         = "Sample glue job to use"
  glue_version        = "4.0"
  timeout             = 600
  worker_type         = "Standard"
  number_of_workers   = 2
  connections         = ""
  python_version      = 3
  script_location     = "s3://${local.artifacts_bucket}/${module.glue_scripts.files["write_job.py"].key}"
  max_concurrent_runs = 1
  runtime_arguments = jsonencode({
    "--datalake-formats":"delta",
    "--continuous-log-logGroup": "/aws/glue/output",
    "--enable-continuous-cloudwatch-log":"true",
    "--enable-continuous-log-filter":"true",
    "--additional-python-modules":"s3://${local.artifacts_bucket}/${module.glue_wheels.files["awswrangler-3.2.1-py3-none-any.whl"].key}",
    "--short-env" : "dev"
    }
  )
}

module "merge_job" {
  source = "../modules/glue"

  name                = "${local.project_name}-merge-job"
  description         = "Sample glue job to use"
  glue_version        = "4.0"
  timeout             = 600
  worker_type         = "Standard"
  number_of_workers   = 2
  connections         = ""
  python_version      = 3
  script_location     = "s3://${local.artifacts_bucket}/${module.glue_scripts.files["merge_job.py"].key}"
  max_concurrent_runs = 1
  runtime_arguments = jsonencode({
    "--datalake-formats":"delta",
    "--continuous-log-logGroup": "/aws/glue/output",
    "--enable-continuous-cloudwatch-log":"true",
    "--enable-continuous-log-filter":"true",
    "--additional-python-modules":"s3://${local.artifacts_bucket}/${module.glue_wheels.files["awswrangler-3.2.1-py3-none-any.whl"].key}",
    "--short-env" : "dev"
    }
  )
}

