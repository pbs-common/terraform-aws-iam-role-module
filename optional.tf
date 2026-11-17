variable "name" {
  description = "Name of the IAM role. If use_prefix is true, this will be the prefix of the role name. If null, will default to `product` value."
  default     = null
  type        = string
}

variable "use_prefix" {
  description = "Use prefix instead of explicit name"
  default     = true
  type        = bool
}

variable "policy_json" {
  description = "(optional) Policy document providing permissions on this role. When null, no customer managed policy is created and the role's permissions come from `aws_managed_policies` alone — as is the case for a role whose only job is to carry an AWS managed policy, such as an ECS task execution role."
  default     = null
  type        = string
}

variable "policy_name" {
  description = "(optional) Exact name for the customer managed policy created from `policy_json`. When null, the policy is named with the prefix `$${name}-policy-` and AWS appends a unique suffix. Set this to adopt a policy that already exists under a fixed name, since a policy cannot switch between a generated and a fixed name without being replaced. Unlike `use_prefix`, which governs the role name, this is always an exact name."
  default     = null
  type        = string
}

variable "aws_services" {
  description = "AWS services that will be assuming this role. e.g. [lambda, edgelambda]"
  type        = set(string)
  default     = []
}


variable "assume_role_policy" {
  description = "JSON string of the assume role policy. If null, assumes that aws_services have been provided."
  default     = null
  type        = string
}

variable "create_instance_profile" {
  description = "Create an instance profile for this role"
  default     = false
  type        = bool
}

variable "permissions_boundary_arn" {
  description = "ARN of the permissions boundary to use for this role"
  default     = null
  type        = string
}

variable "path" {
  description = "Path to the role"
  default     = null
  type        = string
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds for this role, i.e. how long credentials from an AssumeRole last. Null leaves it unset, which AWS treats as the 1 hour default."
  default     = null
  type        = number
  validation {
    condition     = var.max_session_duration == null || try(var.max_session_duration >= 3600 && var.max_session_duration <= 43200, false)
    error_message = "The max_session_duration variable must be between 3600 and 43200 seconds (1 to 12 hours)."
  }
}

variable "aws_managed_policies" {
  description = "List of AWS managed policy names to attach to the role (e.g. [\"AmazonS3ReadOnlyAccess\"])"
  default     = []
  type        = list(string)
}
