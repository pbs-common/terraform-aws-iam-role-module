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
