# The customer managed policy and its attachment became conditional so that a role can rely on
# aws_managed_policies alone. That turned their addresses from a bare resource into a counted one,
# which Terraform would otherwise read as "destroy the old, create the new".
#
# These blocks make the upgrade a no-op for callers that pass policy_json. A caller that upgrades
# and drops policy_json will see the policy destroyed, which is the point of leaving it out.

moved {
  from = aws_iam_policy.policy
  to   = aws_iam_policy.policy[0]
}

moved {
  from = aws_iam_role_policy_attachment.policy_attachment
  to   = aws_iam_role_policy_attachment.policy_attachment[0]
}