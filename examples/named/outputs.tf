output "arn" {
  value = module.role.arn
}

output "policy_name" {
  description = "Name of the policy, pinned exactly rather than generated"
  value       = module.role.policy_name
}