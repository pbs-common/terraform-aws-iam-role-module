module "role" {
  source = "../.."

  policy_json  = data.aws_iam_policy_document.policy_document.json
  aws_services = ["lambda"]

  name       = var.role_name
  use_prefix = false

  # The policy takes an exact name too, rather than a generated one. Without this the role would
  # have a fixed name but its policy would not, which is what blocks adopting a policy that
  # already exists.
  policy_name = "${var.role_name}-permissions"

  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
  organization = var.organization
}
