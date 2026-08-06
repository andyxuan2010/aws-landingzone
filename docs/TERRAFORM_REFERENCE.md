<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.58.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | ../aws-template/modules/kms_key | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ../aws-template/modules/s3_bucket | n/a |
| <a name="module_terraform_execution_role"></a> [terraform\_execution\_role](#module\_terraform\_execution\_role) | ../aws-template/modules/iam_role | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../aws-template/modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codepipeline.terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_iam_role.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket.pipeline_artifacts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.pipeline_artifacts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.pipeline_artifacts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS deployment region. | `string` | `"us-east-1"` | no |
| <a name="input_enable_codepipeline"></a> [enable\_codepipeline](#input\_enable\_codepipeline) | Create CodePipeline, CodeBuild, and artifact storage. This incurs usage charges. | `bool` | `false` | no |
| <a name="input_enable_kms_key"></a> [enable\_kms\_key](#input\_enable\_kms\_key) | Create a customer-managed KMS key. This incurs a monthly charge. | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Create one NAT gateway. This incurs hourly and data-processing charges. | `bool` | `false` | no |
| <a name="input_enable_storage_bucket"></a> [enable\_storage\_bucket](#input\_enable\_storage\_bucket) | Create encrypted workload storage. Storage and requests incur usage charges. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Landing-zone environment. | `string` | `"dev"` | no |
| <a name="input_github_branch"></a> [github\_branch](#input\_github\_branch) | Git branch consumed by CodePipeline. | `string` | `"main"` | no |
| <a name="input_github_connection_arn"></a> [github\_connection\_arn](#input\_github\_connection\_arn) | Placeholder CodeStar Connections ARN for the GitHub source action. | `string` | `"arn:aws:codestar-connections:us-east-1:000000000000:connection/00000000-0000-0000-0000-000000000000"` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GitHub owner/repository consumed by CodePipeline. | `string` | `"CCOE-Azure/aws-landingzone"` | no |
| <a name="input_offline_mode"></a> [offline\_mode](#input\_offline\_mode) | Skip AWS credential and account checks for local/CI validation only. | `bool` | `false` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code used by aws-template naming. | `string` | `"use1"` | no |
| <a name="input_storage_bucket_name"></a> [storage\_bucket\_name](#input\_storage\_bucket\_name) | Globally unique workload bucket name; required when enable\_storage\_bucket is true. | `string` | `"placeholder-replace-before-deployment"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets passed to the reusable VPC module. | <pre>map(object({<br>    cidr_block              = string<br>    availability_zone       = string<br>    public                  = optional(bool, false)<br>    map_public_ip_on_launch = optional(bool, false)<br>    tags                    = optional(map(string), {})<br>  }))</pre> | <pre>{<br>  "private-a": {<br>    "availability_zone": "us-east-1a",<br>    "cidr_block": "10.20.10.0/24"<br>  },<br>  "private-b": {<br>    "availability_zone": "us-east-1b",<br>    "cidr_block": "10.20.11.0/24"<br>  },<br>  "public-a": {<br>    "availability_zone": "us-east-1a",<br>    "cidr_block": "10.20.0.0/24",<br>    "public": true<br>  },<br>  "public-b": {<br>    "availability_zone": "us-east-1b",<br>    "cidr_block": "10.20.1.0/24",<br>    "public": true<br>  }<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags merged with mandatory landing-zone tags. | `map(string)` | `{}` | no |
| <a name="input_terraform_execution_policy_arns"></a> [terraform\_execution\_policy\_arns](#input\_terraform\_execution\_policy\_arns) | Approved managed policies for the generated execution role. Empty by default until least-privilege policies are available. | `set(string)` | `[]` | no |
| <a name="input_terraform_execution_role_arn"></a> [terraform\_execution\_role\_arn](#input\_terraform\_execution\_role\_arn) | Optional AWS role assumed by CodeBuild for Terraform deployment. | `string` | `""` | no |
| <a name="input_terraform_permissions_boundary_arn"></a> [terraform\_permissions\_boundary\_arn](#input\_terraform\_permissions\_boundary\_arn) | Optional permissions boundary for the generated Terraform execution role. | `string` | `null` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | IPv4 CIDR for the landing-zone VPC. | `string` | `"10.20.0.0/16"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier used in resource names. | `string` | `"landing-zone"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_landing_zone"></a> [landing\_zone](#output\_landing\_zone) | Landing-zone feature state and resource identifiers. |
<!-- END_TF_DOCS -->