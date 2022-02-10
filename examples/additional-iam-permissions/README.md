<!-- BEGIN_TF_DOCS -->
# Additional IAM Permissions

Configuration in this directory creates the Prefect agent deployed on a single EC2 instance in an autoscaling group as well as a lightweight network to host the agent.  It also creates an additional IAM policy and attaches it to the existing IAM role for the Prefect agent.

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

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.74.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_prefect"></a> [prefect](#module\_prefect) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy.additional_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | private pem key to apply to the prefect instances | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | cidr range to apply to your vpc | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->