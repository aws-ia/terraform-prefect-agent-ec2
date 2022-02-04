package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesAdditionalIamPermissions(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/additional-iam-permissions",

		Vars: map[string]interface{}{
			"key_name": "prefect",
			"vpc_cidr": "10.0.0.0/24",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}