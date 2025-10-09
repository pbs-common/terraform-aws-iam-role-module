resource "aws_iam_policy" "permission_boundary" {
  name   = local.permission_boundary_name
  policy = data.aws_iam_policy_document.permissions_boundary_policy_document.json
}

module "role" {
  source = "../.."

  policy_json  = data.aws_iam_policy_document.policy_document.json
  aws_services = ["lambda"]

  permissions_boundary_arn = aws_iam_policy.permission_boundary.arn

  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
  organization = var.organization
}
