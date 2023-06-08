provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Initiative       = local.initiative
      Owner            = local.owner
      Manager          = local.manager
      BackendBucket    = "hx-datainitiative-backend"
      BackendKey       = local.project_name
      DeleteProtection = local.delete_protection
    }
  }
}

terraform {
  backend "s3" {
    bucket = "hx-datainitiative-backend"
    key    = "deltalake/terraform.tfstate" # It must be a constant string
    region = "us-east-1"
  }
}