locals {
  environment = terraform.workspace == "default" ? "dev" : terraform.workspace
  name_prefix = "${local.environment}-demo"
}