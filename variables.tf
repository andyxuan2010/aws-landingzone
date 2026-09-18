variable "aws_region" {
  description = "AWS deployment region."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Landing-zone environment."
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["prod", "staging", "dev", "qa", "test", "sbx", "poc"], var.environment)
    error_message = "environment must be prod, staging, dev, qa, test, sbx, or poc."
  }
}

variable "workload" {
  description = "Workload identifier used in resource names."
  type        = string
  default     = "landing-zone"
}

variable "region_code" {
  description = "Short region code used by aws-template naming."
  type        = string
  default     = "use1"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR for the landing-zone VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "subnets" {
  description = "Subnets passed to the reusable VPC module."
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    public                  = optional(bool, false)
    map_public_ip_on_launch = optional(bool, false)
    tags                    = optional(map(string), {})
  }))
  default = {
    public-a  = { cidr_block = "10.20.0.0/24", availability_zone = "us-east-1a", public = true }
    public-b  = { cidr_block = "10.20.1.0/24", availability_zone = "us-east-1b", public = true }
    private-a = { cidr_block = "10.20.10.0/24", availability_zone = "us-east-1a" }
    private-b = { cidr_block = "10.20.11.0/24", availability_zone = "us-east-1b" }
  }
}

variable "enable_nat_gateway" {
  description = "Create one NAT gateway. This incurs hourly and data-processing charges."
  type        = bool
  default     = false
}

variable "enable_kms_key" {
  description = "Create a customer-managed KMS key. This incurs a monthly charge."
  type        = bool
  default     = false
}

variable "enable_storage_bucket" {
  description = "Create encrypted workload storage. Storage and requests incur usage charges."
  type        = bool
  default     = false
}

variable "storage_bucket_name" {
  description = "Globally unique workload bucket name; required when enable_storage_bucket is true."
  type        = string
  default     = "placeholder-replace-before-deployment"
}

variable "enable_codepipeline" {
  description = "Create CodePipeline, CodeBuild, and artifact storage. This incurs usage charges."
  type        = bool
  default     = false
}

variable "github_connection_arn" {
  description = "Placeholder CodeStar Connections ARN for the GitHub source action."
  type        = string
  default     = "arn:aws:codestar-connections:us-east-1:000000000000:connection/00000000-0000-0000-0000-000000000000"
}

variable "github_repository" {
  description = "GitHub owner/repository consumed by CodePipeline."
  type        = string
  default     = "CCOE-Azure/aws-landingzone"
}

variable "github_branch" {
  description = "Git branch consumed by CodePipeline."
  type        = string
  default     = "main"
}

variable "terraform_execution_role_arn" {
  description = "Optional AWS role assumed by CodeBuild for Terraform deployment."
  type        = string
  default     = ""
}

variable "terraform_execution_policy_arns" {
  description = "Approved managed policies for the generated execution role. Empty by default until least-privilege policies are available."
  type        = set(string)
  default     = []
}

variable "terraform_permissions_boundary_arn" {
  description = "Optional permissions boundary for the generated Terraform execution role."
  type        = string
  default     = null
}

variable "offline_mode" {
  description = "Skip AWS credential and account checks for local/CI validation only."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags merged with mandatory landing-zone tags."
  type        = map(string)
  default     = {}
}
