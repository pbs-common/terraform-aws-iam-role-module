module "role" {
  source = "../.."

  policy_json  = data.aws_iam_policy_document.policy_document.json
  aws_services = ["lambda"]

  name       = var.role_name
  use_prefix = false

  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
  organization = var.organization
}
