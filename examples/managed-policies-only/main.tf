# A role whose only job is to carry an AWS managed policy — an ECS task execution role, say.
#
# policy_json is left out, so no customer managed policy is created and the role's permissions come
# from aws_managed_policies alone.
module "role" {
  source = "../.."

  aws_services = ["ecs-tasks"]

  aws_managed_policies = [
    "service-role/AmazonECSTaskExecutionRolePolicy",
  ]

  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
  organization = var.organization
}