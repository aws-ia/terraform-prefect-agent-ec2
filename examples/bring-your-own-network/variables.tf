variable "vpc_id" {
  type        = string
  description = "id of the vpc to deploy the prefect agent into"
}
variable "subnet_ids" {
  type        = list(string)
  description = "ids of the subnets to assign to the autoscaling group"
}
variable "key_name" {
  type        = string
  description = "private pem key to apply to the prefect instances"
}