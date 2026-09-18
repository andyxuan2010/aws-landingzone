# Deployment setup

## Placeholders to replace

1. Create one S3 state bucket per environment or a shared bucket with isolated keys; update each `environments/*/backend.hcl`.
2. Configure GitHub-to-AWS OIDC and store the deploy role ARN as the `AWS_TERRAFORM_ROLE_ARN` environment secret.
3. Set repository/environment variables `AWS_REGION`, `GH_TF_TEMPLATE_REPO`, `ENABLE_AWS_PLAN`, and—only after approval—`ENABLE_AWS_APPLY`. `GH_TF_TEMPLATE_REPO` falls back to the public `andyxuan2010/aws-template` mirror when unset. Select a private repository only when it is readable by the workflow.
4. Add `STAGE_REPO_TOKEN` with write permission to `andyxuan2010/aws-landingzone`.
5. For CodePipeline, create and activate an AWS CodeStar Connections GitHub connection, replace `github_connection_arn`, then enable `enable_codepipeline`.
6. Supply reviewed least-privilege policy ARNs in `terraform_execution_policy_arns` (and preferably `terraform_permissions_boundary_arn`). The generated role deliberately has no deployment permissions by default.

## Guardrails

All paid capabilities default to `false`. GitHub push and pull-request events cannot apply. CodePipeline plans by default and applies only when its CodeBuild environment variable is deliberately changed. Production should use environment approvals and a narrowly scoped execution role before any apply is enabled.

The reusable module checkout is expected at `../aws-template`. Both pipelines create this sibling layout before Terraform initialization.
