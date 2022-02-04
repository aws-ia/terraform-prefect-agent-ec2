package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesPrefect(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/prefect",

		Vars: map[string]interface{}{
			"key_name": "prefect",
			"vpc_id": "vpc-06abcaf941d62184c",
			"subnet_ids": []string{"subnet-01a839cb67a879e99","subnet-08df3dd9fb4c1d937"},
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}