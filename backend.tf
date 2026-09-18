terraform {
  # The S3 backend is configured at init time with environments/<env>/backend.hcl.
  backend "s3" {}
}
