locals {
  name        = var.name != null ? var.name : var.product
  role        = var.use_prefix ? null : local.name
  role_prefix = var.use_prefix ? "${local.name}-" : null

  # Without a policy document there is nothing to put in a customer managed policy, so the role
  # relies on aws_managed_policies alone.
  create_policy = var.policy_json != null

  # A managed policy takes either a generated-with-suffix name or an exact one, never both.
  policy_name        = var.policy_name
  policy_name_prefix = var.policy_name == null ? "${local.name}-policy-" : null

  generate_assume_role_policy = var.assume_role_policy == null
  assume_role_policy          = var.assume_role_policy != null ? var.assume_role_policy : data.aws_iam_policy_document.assume_role_policy[0].json

  creator = "terraform"

  defaulted_tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:environment" = var.environment
      "${var.organization}:billing:owner"       = var.owner
      creator                                   = local.creator
      repo                                      = var.repo
    }
  )

  tags = merge({ for k, v in local.defaulted_tags : k => v if lookup(data.aws_default_tags.common_tags.tags, k, "") != v })
}

data "aws_default_tags" "common_tags" {}
