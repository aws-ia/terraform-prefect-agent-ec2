<!-- BEGIN_TF_DOCS -->
# Basic

Configuration in this directory creates the Prefect agent deployed on a single EC2 instance in an autoscaling group. It also creates a lightweight network to host the agent.

![architecture diagram](https://github.com/aws-ia/terraform-prefect-agent-ec2/tree/main/images/basic.png)

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

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->