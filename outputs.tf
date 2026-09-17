output "landing_zone" {
  description = "Landing-zone feature state and resource identifiers."
  value = {
    vpc_id             = module.vpc.vpc_id
    public_subnet_ids  = module.vpc.public_subnet_ids
    private_subnet_ids = module.vpc.private_subnet_ids
    terraform_role_arn = module.terraform_execution_role.role_arn
    kms_key_arn        = var.enable_kms_key ? module.kms[0].key_arn : null
    storage_bucket_arn = var.enable_storage_bucket ? module.storage[0].bucket_arn : null
    pipeline_name      = var.enable_codepipeline ? aws_codepipeline.terraform[0].name : null
  }
}
