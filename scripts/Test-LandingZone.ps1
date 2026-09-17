[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$moduleRepo = Join-Path (Split-Path -Parent $root) "aws-template"

if (-not (Test-Path $moduleRepo)) {
  throw "Expected reusable module repository at $moduleRepo"
}

Push-Location $root
try {
  terraform fmt -check -recursive
  if ($LASTEXITCODE -ne 0) { throw "terraform fmt check failed" }

  terraform init -backend=false -input=false
  if ($LASTEXITCODE -ne 0) { throw "terraform init failed" }

  terraform validate
  if ($LASTEXITCODE -ne 0) { throw "terraform validate failed" }

  terraform-docs .
  if ($LASTEXITCODE -ne 0) { throw "terraform-docs failed" }
}
finally {
  Pop-Location
}
