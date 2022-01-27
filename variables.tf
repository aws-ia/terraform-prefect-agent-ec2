variable "instance_type" {
  type        = string
  description = "AWS instance type"
  default     = "t3.medium"
}
variable "ami_id" {
  type        = string
  description = "ami to launch the ec2 instance from, windows images not supported"
}
variable "linux_type" {
  type        = string
  description = "type of linux instance"
  default     = "linux_amd64"
}
variable "min_capacity" {
  type        = number
  description = "the minimum size of the auto scaling group"
  default     = 1
}
variable "max_capacity" {
  type        = number
  description = "the maximum size of the auto scaling group"
  default     = 1
}
variable "desired_capacity" {
  type        = number
  description = "the number of prefect agents that should be running in the auto scaling group"
  default     = 1
}
variable "enable_detailed_monitoring" {
  type        = bool
  description = "enable detailed monitoring on the prefect agent (1 min intervals)"
  default     = true
}
variable "key_name" {
  type        = string
  description = "private pem key to apply to the prefect instances"
  default     = null
}

## vars for prefect bootstrap script
variable "prefect_api_key_secret_name" {
  type        = string
  description = "id of aws secrets manager secret for prefect api key"
  default     = "prefect-api-key"
}
variable "prefect_secret_key" {
  type        = string
  description = "key of aws secrets manager secret for prefect api key"
  default     = "key"
}
variable "prefect_api_address" {
  type        = string
  description = "the api address that the prefect agent queries for pending flow runs"
  default     = "https://api.prefect.io"
}
variable "prefect_labels" {
  type        = string
  description = "labels to apply to the prefect agent" # DESCRIBE EXACT TYPE 
  default     = "[]"
}
variable "disable_image_pulling" {
  type        = string
  description = "disables the prefect agents ability to pull non-local images"
  default     = false
}
variable "enable_local_flow_logs" {
  type = bool
  description = "enables flow logs to output locally on the agent"
  default = false
}



variable "vpc_id" {
  type        = string
  description = "id of the vpc to deploy the prefect agent into"
}
variable "subnet_ids" {
  type        = list(string)
  description = "ids of the subnets to assign to the autoscaling group"
}



variable "security_group_ids" {
  type        = list(string)
  description = "security group(s) to attach to the prefect launch template, if not provided, a default one will be created"
  default     = null
}


variable "iam_role_id" {
  type        = string
  description = "iam role to attach to the prefect launch template, if not provided, a default one will be created"
  default     = null
}
variable "attach_ssm_policy" {
  type        = bool
  description = "Attach ssm policy to the prefect iam role"
  default     = true
}
variable "custom_tags" {
  description = "custom tags which can be passed on to the AWS resources. they should be key value pairs having distinct keys."
  type        = map(any)
  default     = {}
}
