output "arn" {
  value = module.role.arn
}

output "policy_arn" {
  description = "Null here: no customer managed policy is created without policy_json"
  value       = module.role.policy_arn
}