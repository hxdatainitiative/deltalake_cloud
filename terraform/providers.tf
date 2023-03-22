provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Initiative       = local.initative
      Owner            = local.owner
      Manager          = local.manager
      BackendBucket    = "hx-datainitiative-backend"
      BackendKey       = local.replace_with_your_project_name
      DeleteProtection = local.delete_protection
    }
  }
}

terraform {
  backend "s3" {
    bucket = "hx-datainitiative-backend"
    key    = "${local.replace_with_your_project_name}/terraform.tfstate" # It must be a constant string
    region = var.aws_region
  }
}