# AWS Landing Zone

Terraform composition for a small, secure AWS landing-zone baseline. It follows the sibling `azure-landingzone` repository's environment and pipeline conventions and consumes reusable modules from the sibling `aws-template` repository.

## Safe baseline

The default configuration creates a VPC with public/private subnets, route tables, an internet gateway, and a Terraform execution IAM role. NAT Gateway, KMS, S3 workload storage, CodeBuild, and CodePipeline are disabled because they can incur charges. This repository contains placeholders and must not be applied until the AWS account, OIDC role, state bucket, and connection ARN are configured.

## Local validation

Keep `aws-template` beside this repository, then run:

```powershell
./scripts/Test-LandingZone.ps1
```

For a real plan, replace the backend placeholders and authenticate to AWS:

```bash
terraform init -reconfigure -backend-config=environments/dev/backend.hcl
terraform plan -var-file=environments/dev/terraform.tfvars
```

## Delivery paths

- GitHub Actions always runs format and validation. The GitHub variable `GH_TF_TEMPLATE_REPO` selects the reusable module repository and falls back to the public `andyxuan2010/aws-template` mirror. Plans require `ENABLE_AWS_PLAN=true`; applies additionally require a manual dispatch, `apply=true`, `ENABLE_AWS_APPLY=true`, an approved GitHub Environment, and `AWS_TERRAFORM_ROLE_ARN`.
- A successful `main` validation publishes a clean snapshot to `andyxuan2010/aws-landingzone` when `STAGE_REPO_TOKEN` is configured.
- AWS CodePipeline is provisioned only with `enable_codepipeline=true`. Its CodeBuild project runs `buildspec.yml`; apply remains gated by `ENABLE_CODEPIPELINE_APPLY=false`.

See [deployment setup](docs/DEPLOYMENT.md), [architecture](docs/ARCHITECTURE.md), and the [generated Terraform reference](docs/TERRAFORM_REFERENCE.md).
