output "arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.role.arn
}

output "name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.role.name
}

output "policy_arn" {
  description = "ARN of the customer managed policy created from policy_json. Null when policy_json was not provided."
  value       = one(aws_iam_policy.policy[*].arn)
}

output "policy_name" {
  description = "Name of the customer managed policy created from policy_json. Generated unless policy_name was set, and null when policy_json was not provided."
  value       = one(aws_iam_policy.policy[*].name)
}

