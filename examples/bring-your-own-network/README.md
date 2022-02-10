<!-- BEGIN_TF_DOCS -->
# Bring Your Own Network

Configuration in this directory creates the Prefect agent deployed on a single EC2 instance in an autoscaling group.

[architecture diagram](../../images/bring-your-own-network.png)

## Usage

To run this example you need to execute:
```
$ terraform init
$ terraform plan
$ terraform apply
```
Note that this example may create resources which can cost money (AWS EC2, for example). Run terraform destroy when you don't need these resources.

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
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | private pem key to apply to the prefect instances | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | ids of the subnets to assign to the autoscaling group | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | id of the vpc to deploy the prefect agent into | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->