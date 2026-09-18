provider "aws" {
  region = var.aws_region

  skip_credentials_validation = var.offline_mode
  skip_metadata_api_check     = var.offline_mode
  skip_region_validation      = var.offline_mode
  skip_requesting_account_id  = var.offline_mode

  default_tags {
    tags = local.common_tags
  }
}
