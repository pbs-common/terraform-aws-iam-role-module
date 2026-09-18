package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testIAMRole(t *testing.T, variant string) {
	t.Parallel()

	terraformDir := fmt.Sprintf("../examples/%s", variant)

	vars := map[string]interface{}{}
	namedRoleNameVar := ""
	if variant == "named" {
		namedRoleName := RandomString(5)
		namedRoleNameVar = fmt.Sprintf("example-tf-iam-role-named-%s", namedRoleName)
		vars = map[string]interface{}{
			"role_name": namedRoleNameVar,
		}
	} else if variant == "prefix" {
		rolePrefix := RandomString(5)
		vars = map[string]interface{}{
			"role_prefix": fmt.Sprintf("example-tf-iam-role-prefix-%s", rolePrefix),
		}
	}

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDir,
		LockTimeout:  "5m",
		Vars:         vars,
		Upgrade:      true,
	}

	defer terraform.Destroy(t, terraformOptions)

	expectedName := fmt.Sprintf("example-tf-iam-role-%s", variant)

	terraform.InitAndApply(t, terraformOptions)

	arn := terraform.Output(t, terraformOptions, "arn")
	assert.Contains(t, arn, expectedName)

	// The named variant pins the policy name as well, so it must come back verbatim rather than
	// carrying the suffix AWS appends to a generated name.
	if variant == "named" {
		policyName := terraform.Output(t, terraformOptions, "policy_name")
		assert.Equal(t, fmt.Sprintf("%s-permissions", namedRoleNameVar), policyName)
	}
}
