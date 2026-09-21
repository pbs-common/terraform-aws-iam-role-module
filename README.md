# TF IAM Role Module

## Installation

### Using the Repo Source

```hcl
github.com/pbs/terraform-aws-iam-role-module?ref=x.y.z
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module provisions an IAM role.

It is assumed that this role will be used by an AWS service. As such, the optional `aws_services` parameter is frequently used. This parameter populates the trust relationship that allows AWS services to assume the role.

It is recommended that you use the `aws_iam_policy_document` data source to generate the JSON string passed into `policy_json`. This ensures that changes to your policy are detected and rendered correctly on plans and applies.

The exception to this recommendation is when some complex logic is involved in resolving a dynamic policy. In this case, it can be advantageous to use the `jsonencode` function to encode the Terraform dictionary as a json string.

### Permissions

A role's permissions can come from either or both of:

- `policy_json` — a customer managed policy this module creates and attaches.
- `aws_managed_policies` — names of existing AWS managed policies to attach, e.g. `["service-role/AmazonECSTaskExecutionRolePolicy"]`.

`policy_json` is optional. Leave it out for a role whose only job is to carry an AWS managed policy, such as an ECS task execution role — no customer managed policy is created, and the `policy_arn` and `policy_name` outputs are null. See [the managed-policies-only example](/examples/managed-policies-only).

Integrate this module like so:

```hcl
module "role" {
  source = "github.com/pbs/terraform-aws-iam-role-module?ref=x.y.z"

  policy_json = data.aws_iam_policy_document.policy_document.json

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
  aws_services = ["lambda"]
}
```

### Naming

By default both the role and the policy are named with a prefix, letting AWS append a unique suffix. The two are controlled separately:

| Variable | Governs | Default |
|---|---|---|
| `use_prefix` | The role name. When false, the role takes `name` exactly. | `true` |
| `policy_name` | The policy name. When set, the policy takes it exactly, regardless of `use_prefix`. | `null` (prefix `<name>-policy-`) |

Pin both when adopting resources that already exist under fixed names — neither a role nor a policy can switch between a generated and a fixed name without being replaced:

```hcl
module "role" {
  source = "github.com/pbs/terraform-aws-iam-role-module?ref=x.y.z"

  policy_json = data.aws_iam_policy_document.policy_document.json

  name        = "my-app-prod-ecs-tasks"
  use_prefix  = false
  policy_name = "my-app-prod-permissions"

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
}
```

See [the named example](/examples/named).

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`x.y.z`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.62.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_managed_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | JSON string of the assume role policy. If null, assumes that aws\_services have been provided. | `string` | `null` | no |
| <a name="input_aws_managed_policies"></a> [aws\_managed\_policies](#input\_aws\_managed\_policies) | List of AWS managed policy names to attach to the role (e.g. ["AmazonS3ReadOnlyAccess"]) | `list(string)` | `[]` | no |
| <a name="input_aws_services"></a> [aws\_services](#input\_aws\_services) | AWS services that will be assuming this role. e.g. [lambda, edgelambda] | `set(string)` | `[]` | no |
| <a name="input_create_instance_profile"></a> [create\_instance\_profile](#input\_create\_instance\_profile) | Create an instance profile for this role | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the IAM role. If use\_prefix is true, this will be the prefix of the role name. If null, will default to `product` value. | `string` | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | Path to the role | `string` | `null` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | ARN of the permissions boundary to use for this role | `string` | `null` | no |
| <a name="input_policy_json"></a> [policy\_json](#input\_policy\_json) | (optional) Policy document providing permissions on this role. When null, no customer managed policy is created and the role's permissions come from `aws_managed_policies` alone — as is the case for a role whose only job is to carry an AWS managed policy, such as an ECS task execution role. | `string` | `null` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | (optional) Exact name for the customer managed policy created from `policy_json`. When null, the policy is named with the prefix `${name}-policy-` and AWS appends a unique suffix. Set this to adopt a policy that already exists under a fixed name, since a policy cannot switch between a generated and a fixed name without being replaced. Unlike `use_prefix`, which governs the role name, this is always an exact name. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_use_prefix"></a> [use\_prefix](#input\_use\_prefix) | Use prefix instead of explicit name | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the IAM role |
| <a name="output_name"></a> [name](#output\_name) | Name of the IAM role |
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | ARN of the customer managed policy created from policy\_json. Null when policy\_json was not provided. |
| <a name="output_policy_name"></a> [policy\_name](#output\_policy\_name) | Name of the customer managed policy created from policy\_json. Generated unless policy\_name was set, and null when policy\_json was not provided. |
