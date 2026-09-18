# Validation

Run `scripts/Test-LandingZone.ps1` to check formatting, initialize without the remote backend, validate the configuration, and regenerate the Terraform reference. The test uses `offline_mode=true` only as a validation convention; no plan or apply is attempted without AWS credentials.

The documentation portal is built separately with `scripts/Build-DocsSite.ps1` and checked with `scripts/Test-DocsSite.ps1`. The generated `_site/` directory is intentionally ignored because it is a CI build artifact.
