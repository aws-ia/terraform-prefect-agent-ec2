variable "vpc_cidr" {
  type        = string
  description = "cidr range to apply to your vpc"
}
variable "key_name" {
  type        = string
  description = "private pem key to apply to the prefect instances"
}