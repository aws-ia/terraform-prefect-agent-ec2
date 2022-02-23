<!-- BEGIN_TF_DOCS -->
# Agent Configuration Options

Configuration in this directory creates the Prefect Docker agent deployed on a single EC2 instance in an autoscaling group as well as a lightweight network to host the agent.  It also provides additional configuration to the agent like [labels](https://docs.prefect.io/orchestration/agents/overview.html#labels) & an [automation id](https://docs.prefect.io/orchestration/concepts/automations.html#overview).

## Usage

To run this example you need to execute:
```
$ terraform init
$ terraform plan
$ terraform apply
```
Note that this example may create resources which can cost money (AWS EC2, VPC endpoints, NAT gateway, for example). Run terraform destroy when you don't need these resources.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_prefect"></a> [prefect](#module\_prefect) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_automation_config"></a> [agent\_automation\_config](#input\_agent\_automation\_config) | config id to apply to the prefect agent to enable cloud automations | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->