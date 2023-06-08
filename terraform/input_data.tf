data "terraform_remote_state" "shared_services" {
  backend = "s3"

  config = {
    bucket = "hx-datainitiative-backend"
    key    = "shared_services/terraform.tfstate"
    region = var.aws_region
  }
}
