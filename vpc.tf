module "vpc" {
  count   = var.deploy_network ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.4"

  name = "prefect-vpc"
  cidr = var.vpc_cidr

  azs             = ["${data.aws_region.current.id}a", "${data.aws_region.current.id}b"]
  private_subnets = [local.subnet_cidrs[0], local.subnet_cidrs[1]]
  public_subnets  = [local.subnet_cidrs[2], local.subnet_cidrs[3]]

  manage_default_route_table = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = var.enable_single_nat_gateway

  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60


  tags = {
    managed-by = "terraform"
    service    = "prefect"
  }
}

module "vpc_endpoints" {
  count  = var.deploy_network ? 1 : 0
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id     = var.deploy_network ? module.vpc[0].vpc_id : null
  subnet_ids = var.deploy_network ? module.vpc[0].private_subnets : null

  security_group_ids = [aws_security_group.endpoints[0].id]

  endpoints = {
    ecr = {
      service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
      tags                = { Name = "ecr-vpc-endpoint" }
      private_dns_enabled = true
    }
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = var.deploy_network ? module.vpc[0].private_route_table_ids : null
      tags            = { Name = "s3-vpc-endpoint" }
    }
  }
}

resource "aws_security_group" "endpoints" {
  count       = var.deploy_network ? 1 : 0
  name_prefix = "vpc-endpoints"
  description = "Allow HTTPS traffic to/from vpc endpoints within the vpc"
  vpc_id      = module.vpc[0].vpc_id

  tags = {
    Name       = "vpc-endpoints"
    managed-by = "terraform"
  }
}

resource "aws_security_group_rule" "vpce_egress" {
  count             = var.deploy_network ? 1 : 0
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = var.deploy_network ? aws_security_group.endpoints[0].id : null
}

resource "aws_security_group_rule" "vpce_ingress" {
  count             = var.deploy_network ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = var.deploy_network ? aws_security_group.endpoints[0].id : null
}