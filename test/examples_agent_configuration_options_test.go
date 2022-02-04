package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesAgentConfigurationOptions(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/agent-configuration-options",

		Vars: map[string]interface{}{
			"agent_automation_config": "98dn3ks8-aafg-98s8-j37d-k9sn4uf8sn3k",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}