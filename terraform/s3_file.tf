module "glue_scripts" {
  source = "../modules/s3"

  file_path    = "../code/glue"
  file_pattern = "*.py"
  bucket       = local.artifacts_bucket
}

module "glue_wheels" {
  source = "../modules/s3"

  file_path    = "../code/layers"
  file_pattern = "*.whl"
  bucket       = local.artifacts_bucket
}
