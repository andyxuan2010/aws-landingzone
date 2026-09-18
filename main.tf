module "vpc" {
  source = "../aws-template/modules/vpc"

  workload                = var.workload
  region_code             = var.region_code
  environment             = var.environment
  cidr_block              = var.vpc_cidr
  subnets                 = var.subnets
  nat_gateway_mode        = var.enable_nat_gateway ? "single" : "none"
  enable_internet_gateway = true
  inherited_tags          = local.common_tags
}

module "terraform_execution_role" {
  source = "../aws-template/modules/iam_role"

  workload                 = "${var.workload}-terraform"
  environment              = var.environment
  description              = "Landing-zone Terraform execution role"
  inherited_tags           = local.common_tags
  managed_policy_arns      = var.terraform_execution_policy_arns
  permissions_boundary_arn = var.terraform_permissions_boundary_arn
  trust_policy_statements = [{
    sid     = "AllowCodeBuildAssumeRole"
    actions = ["sts:AssumeRole"]
    principals = [{
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }]
  }]
}

module "kms" {
  count  = var.enable_kms_key ? 1 : 0
  source = "../aws-template/modules/kms_key"

  workload       = var.workload
  region_code    = var.region_code
  environment    = var.environment
  inherited_tags = local.common_tags
}

module "storage" {
  count  = var.enable_storage_bucket ? 1 : 0
  source = "../aws-template/modules/s3_bucket"

  name           = var.storage_bucket_name
  workload       = var.workload
  region_code    = var.region_code
  environment    = var.environment
  kms_key_arn    = var.enable_kms_key ? module.kms[0].key_arn : null
  inherited_tags = local.common_tags
  lifecycle_rules = {
    housekeeping = {
      noncurrent_version_expiration   = 90
      abort_incomplete_multipart_days = 7
    }
  }
}
