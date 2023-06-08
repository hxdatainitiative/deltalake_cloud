module "glue_scripts" {
  source = "../modules/s3"

  file_path    = "../code/glue"
  file_pattern = "*.py"
  bucket       = local.artifacts_bucket
}
