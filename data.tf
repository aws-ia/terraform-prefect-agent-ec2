data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_secretsmanager_secret" "prefect" {
  name = var.prefect_api_key_secret_name
}

locals {
  image_pulling = var.disable_image_pulling ? "--no-pull" : ""
  flow_logs     = var.enable_local_flow_logs ? "--show-flow-logs" : ""
  subnet_cidrs  = var.deploy_network ? cidrsubnets(var.vpc_cidr, 2, 2, 2, 2) : null
}