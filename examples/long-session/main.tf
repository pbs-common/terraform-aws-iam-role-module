# A role whose assumed-role credentials last longer than AWS's one-hour default.
#
# Worth setting when something holds credentials for the length of a long job -- an ECS task that
# runs for hours, a batch export -- rather than re-assuming periodically. AWS accepts 3600 to
# 43200 seconds; the module validates that range so a typo fails at plan rather than at apply.
#
# Leaving `max_session_duration` unset passes null, which leaves the attribute alone. That matters
# when adopting an existing role: the attribute is optional+computed, so null keeps whatever the
# role already has instead of resetting it to one hour.
module "role" {
  source = "../.."

  policy_json  = data.aws_iam_policy_document.policy_document.json
  aws_services = ["ecs-tasks"]

  max_session_duration = 8 * 60 * 60

  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
  organization = var.organization
}
