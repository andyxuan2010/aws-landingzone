locals {
  common_tags = merge({
    Application = "aws-landing-zone"
    Environment = upper(var.environment)
    ManagedBy   = "Terraform"
    Owner       = "CCOE"
    Repository  = var.github_repository
  }, var.tags)

  pipeline_name = "${var.workload}-${var.environment}-pipeline"
}
