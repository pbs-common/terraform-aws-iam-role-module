module "role" {
  source = "../.."

  policy_json  = data.aws_iam_policy_document.policy_document.json
  aws_services = ["lambda"]

  name = var.role_prefix

  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
  organization = var.organization
}
