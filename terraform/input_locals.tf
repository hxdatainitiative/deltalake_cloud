locals {
  initiative          = "Data Science and Engineering"
  owner               = "fmeza@hexacta.com"
  manager             = "Fernando Meza"
  project_name        = "deltalake"
  project_prefix      = "hx_${local.project_name}"
  backend_key         = "data_initiative/templates"
  delete_protection   = false
  
  raw_bucket       = data.terraform_remote_state.shared_services.outputs.s3_buckets["raw"].s3_bucket_id
  artifacts_bucket = data.terraform_remote_state.shared_services.outputs.s3_buckets["artifacts"].s3_bucket_id
}
