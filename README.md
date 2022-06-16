<!-- BEGIN_TF_DOCS -->
# Prefect Docker Agent on AWS EC2 Module

The [Prefect Agent](https://docs.prefect.io/orchestration/agents/overview.html) is a lightweight process that orchestrates [flow runs](https://docs.prefect.io/core/concepts/flows.html).  It is responsible for starting and monitoring flow runs. During operation the agent process queries the Prefect API for any scheduled flow runs, and allocates resources for them on their respective deployment platforms.

This Terraform module deploys the infrastructure required to run the Prefect Docker agent on AWS EC2. By default, it deploys AWS VPC Networking resources, which are best practice for Prefect configuration. You can disable the default networking as show in the [bring your own network](https://github.com/aws-ia/terraform-prefect-agent-ec2/tree/main/examples/bring-your-own-network) example.

![architecture diagram](https://github.com/aws-ia/terraform-prefect-agent-ec2/blob/bcdbb31cd7ffb55926ccd78c60e2f35c28fc3450/images/basic.png)

## Prerequisites

1. Generate an [API service account key](https://docs.prefect.io/orchestration/concepts/api_keys.html#using-api-keys) for the agent
2. Store the API key in AWS Secrets Manager in the console, or using the following CLI command.  The secret is created by this Terraform module intentionally, as Terraform would store the API key in plaintext within the state file.
```
aws secretsmanager create-secret --name prefect-api-key --secret-string "{\"key\":\"API_KEY_HERE\"}"
```
> Note - if you receive the following error from Terraform, the secret has not been created or the name of the secret provided to Terraform was incorrect.
```
Error: Secrets Manager Secret "prefect-api-key" not found
```

## Examples

Review the `examples/` directory for several specific deployment patterns:
* [Agent Configuration Options](https://github.com/aws-ia/terraform-prefect-agent-ec2/tree/main/examples/agent-configuration-options) - Demonstrates common agent configuration options that can be passed to the module
* [Additional IAM Permissions](https://github.com/aws-ia/terraform-prefect-agent-ec2/tree/main/examples/additional-iam-permissions) - Uses the IAM role built within the module to add additional permissions to the Prefect Agent EC2 Instance
* [Basic](https://github.com/aws-ia/terraform-prefect-agent-ec2/tree/main/examples/basic) - Simple deployment of the module with **no** inputs provided
* [Bring Your Own Network](https://github.com/aws-ia/terraform-prefect-agent-ec2/tree/main/examples/bring-your-own-network) - Demonstrates using network resources that were built outside of the scope of this module

## Agent Configuration

Several agent configuration options are exposed through this module.  Please find more documentation on the following configuration options [here](https://docs.prefect.io/orchestration/agents/overview.html#common-configuration-options).
* [Prefect API address](https://docs.prefect.io/orchestration/agents/overview.html#prefect-api-address)
* [Labels](https://docs.prefect.io/orchestration/agents/overview.html#labels)
* [Agent Automations](https://docs.prefect.io/orchestration/agents/overview.html#agent-automations)
* [Streaming Flow Run Logs](https://docs.prefect.io/orchestration/agents/docker.html#streaming-flow-run-logs)
* [Disabling Image Pulling](https://docs.prefect.io/orchestration/agents/docker.html#disabling-image-pulling)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.72.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.72.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.11.4 |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 3.11.4 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.prefect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy_attachment.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_launch_template.prefect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.prefect_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.vpce_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.vpce_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret.prefect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_automation_config"></a> [agent\_automation\_config](#input\_agent\_automation\_config) | config id to apply to the prefect agent to enable cloud automations | `string` | `""` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | ami to launch the ec2 instance from, windows images not supported | `string` | `""` | no |
| <a name="input_attach_ssm_policy"></a> [attach\_ssm\_policy](#input\_attach\_ssm\_policy) | Attach ssm policy to the prefect iam role | `bool` | `true` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | custom tags which can be passed on to the AWS resources. they should be key value pairs having distinct keys. | `map(any)` | `{}` | no |
| <a name="input_deploy_network"></a> [deploy\_network](#input\_deploy\_network) | deploy lightweight network to host the prefect agent | `bool` | `true` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | the number of prefect agents that should be running in the auto scaling group | `number` | `1` | no |
| <a name="input_disable_image_pulling"></a> [disable\_image\_pulling](#input\_disable\_image\_pulling) | disables the prefect agents ability to pull non-local images | `string` | `false` | no |
| <a name="input_enable_detailed_monitoring"></a> [enable\_detailed\_monitoring](#input\_enable\_detailed\_monitoring) | enable detailed monitoring on the prefect agent (1 min intervals) | `bool` | `true` | no |
| <a name="input_enable_local_flow_logs"></a> [enable\_local\_flow\_logs](#input\_enable\_local\_flow\_logs) | enables flow logs to output locally on the agent | `bool` | `false` | no |
| <a name="input_enable_single_nat_gateway"></a> [enable\_single\_nat\_gateway](#input\_enable\_single\_nat\_gateway) | enable a shared nat gateway within your vpc | `bool` | `false` | no |
| <a name="input_iam_role_id"></a> [iam\_role\_id](#input\_iam\_role\_id) | iam role to attach to the prefect launch template, if not provided, a default one will be created | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | AWS instance type | `string` | `"t3.medium"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | private pem key to apply to the prefect instances | `string` | `null` | no |
| <a name="input_linux_type"></a> [linux\_type](#input\_linux\_type) | type of linux instance | `string` | `"linux_amd64"` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | the maximum size of the auto scaling group | `number` | `1` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | the minimum size of the auto scaling group | `number` | `1` | no |
| <a name="input_prefect_api_address"></a> [prefect\_api\_address](#input\_prefect\_api\_address) | the api address that the prefect agent queries for pending flow runs | `string` | `"https://api.prefect.io"` | no |
| <a name="input_prefect_api_key_secret_name"></a> [prefect\_api\_key\_secret\_name](#input\_prefect\_api\_key\_secret\_name) | id of aws secrets manager secret for prefect api key | `string` | `"prefect-api-key"` | no |
| <a name="input_prefect_labels"></a> [prefect\_labels](#input\_prefect\_labels) | labels to apply to the prefect agent | `string` | `""` | no |
| <a name="input_prefect_secret_key"></a> [prefect\_secret\_key](#input\_prefect\_secret\_key) | key of aws secrets manager secret for prefect api key | `string` | `"key"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | security group(s) to attach to the prefect launch template, if not provided, a default one will be created | `list(string)` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | ids of the subnets to assign to the autoscaling group | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | cidr range to apply to your vpc | `string` | `"192.168.0.0/24"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | id of the vpc to deploy the prefect agent into | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_prefect_role_id"></a> [prefect\_role\_id](#output\_prefect\_role\_id) | iam role id of the role attached to the prefect launch template |
<!-- END_TF_DOCS -->