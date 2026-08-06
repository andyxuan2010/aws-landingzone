resource "aws_s3_bucket" "pipeline_artifacts" {
  count         = var.enable_codepipeline ? 1 : 0
  bucket_prefix = "${var.workload}-${var.environment}-artifacts-"
  force_destroy = false
  tags          = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "pipeline_artifacts" {
  count  = var.enable_codepipeline ? 1 : 0
  bucket = aws_s3_bucket.pipeline_artifacts[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline_artifacts" {
  count  = var.enable_codepipeline ? 1 : 0
  bucket = aws_s3_bucket.pipeline_artifacts[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_iam_role" "codebuild" {
  count              = var.enable_codepipeline ? 1 : 0
  name               = "${local.pipeline_name}-build"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Principal = { Service = "codebuild.amazonaws.com" }, Action = "sts:AssumeRole" }] })
  tags               = local.common_tags
}

resource "aws_iam_role_policy" "codebuild" {
  count = var.enable_codepipeline ? 1 : 0
  role  = aws_iam_role.codebuild[0].id
  policy = jsonencode({ Version = "2012-10-17", Statement = [
    { Effect = "Allow", Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"], Resource = "*" },
    { Effect = "Allow", Action = ["s3:GetObject", "s3:GetObjectVersion", "s3:PutObject", "s3:GetBucketVersioning"], Resource = [aws_s3_bucket.pipeline_artifacts[0].arn, "${aws_s3_bucket.pipeline_artifacts[0].arn}/*"] },
    { Effect = "Allow", Action = "sts:AssumeRole", Resource = var.terraform_execution_role_arn != "" ? var.terraform_execution_role_arn : module.terraform_execution_role.role_arn }
  ] })
}

resource "aws_codebuild_project" "terraform" {
  count        = var.enable_codepipeline ? 1 : 0
  name         = local.pipeline_name
  service_role = aws_iam_role.codebuild[0].arn
  artifacts { type = "CODEPIPELINE" }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name  = "DEPLOY_ENV"
      value = var.environment
    }
    environment_variable {
      name  = "TF_EXECUTION_ROLE_ARN"
      value = var.terraform_execution_role_arn != "" ? var.terraform_execution_role_arn : module.terraform_execution_role.role_arn
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
  tags = local.common_tags
}

resource "aws_iam_role" "codepipeline" {
  count              = var.enable_codepipeline ? 1 : 0
  name               = "${local.pipeline_name}-service"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Principal = { Service = "codepipeline.amazonaws.com" }, Action = "sts:AssumeRole" }] })
  tags               = local.common_tags
}

resource "aws_iam_role_policy" "codepipeline" {
  count = var.enable_codepipeline ? 1 : 0
  role  = aws_iam_role.codepipeline[0].id
  policy = jsonencode({ Version = "2012-10-17", Statement = [
    { Effect = "Allow", Action = ["codestar-connections:UseConnection"], Resource = var.github_connection_arn },
    { Effect = "Allow", Action = ["codebuild:StartBuild", "codebuild:BatchGetBuilds"], Resource = aws_codebuild_project.terraform[0].arn },
    { Effect = "Allow", Action = ["s3:GetObject", "s3:GetObjectVersion", "s3:PutObject", "s3:GetBucketVersioning"], Resource = [aws_s3_bucket.pipeline_artifacts[0].arn, "${aws_s3_bucket.pipeline_artifacts[0].arn}/*"] }
  ] })
}

resource "aws_codepipeline" "terraform" {
  count    = var.enable_codepipeline ? 1 : 0
  name     = local.pipeline_name
  role_arn = aws_iam_role.codepipeline[0].arn
  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts[0].bucket
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      name             = "GitHub"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]
      configuration    = { ConnectionArn = var.github_connection_arn, FullRepositoryId = var.github_repository, BranchName = var.github_branch, DetectChanges = "true" }
    }
  }
  stage {
    name = "ValidatePlan"
    action {
      name            = "Terraform"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]
      configuration   = { ProjectName = aws_codebuild_project.terraform[0].name }
    }
  }
  tags = local.common_tags
}
