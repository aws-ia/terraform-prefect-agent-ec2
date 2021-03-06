resource "aws_launch_template" "prefect" {
  name_prefix = "prefect-agent"
  description = "launches a prefect agent on a specified image"

  image_id      = var.ami_id == "" ? data.aws_ami.amazon_linux_2.id : var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name != null ? var.key_name : null

  vpc_security_group_ids = var.security_group_ids == null ? [aws_security_group.sg[0].id] : var.security_group_ids

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge({
      Name       = "prefect-agent"
      managed-by = "terraform"
    }, var.custom_tags)
  }

  user_data = base64encode(templatefile("${path.module}/prefect-agent.sh.tpl",
    {
      region              = data.aws_region.current.name
      linux_type          = var.linux_type
      prefect_secret_name = var.prefect_api_key_secret_name
      prefect_secret_key  = var.prefect_secret_key
      prefect_api_address = var.prefect_api_address
      prefect_labels      = var.prefect_labels
      image_pulling       = local.image_pulling
      flow_logs           = local.flow_logs
      config_id           = local.config_id
    }
  ))
}

resource "aws_autoscaling_group" "prefect" {
  name_prefix         = "prefect-agent"
  max_size            = var.max_capacity
  min_size            = var.min_capacity
  health_check_type   = "EC2"
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.deploy_network ? module.vpc[0].private_subnets : var.subnet_ids

  lifecycle {
    create_before_destroy = true
  }

  launch_template {
    id      = aws_launch_template.prefect.id
    version = "$Latest" # support other versions?
  }
}

resource "aws_security_group" "sg" {
  count       = var.security_group_ids == null ? 1 : 0
  name_prefix = "prefect-agent"
  description = "allow all outbound traffic from the prefect agent"
  vpc_id      = var.deploy_network ? module.vpc[0].vpc_id : var.vpc_id

  tags = merge({
    Name         = "prefect-agent"
    "managed-by" = "terraform"
  }, var.custom_tags)
}

resource "aws_security_group_rule" "prefect_egress" {
  count       = var.security_group_ids == null ? 1 : 0
  description = "allow all egress traffic to the internet"
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
  # this is neccessary as the IP of Prefect Cloud (or Prefect server) is not static
  # also, ec2 may need to interact with other resources outside of the vpc
  # i.e snowflake, on-prem data sources, etc.
  security_group_id = var.security_group_ids == null ? aws_security_group.sg[0].id : null
}

##########################################
# IAM Policies
##########################################
resource "aws_iam_instance_profile" "instance_profile" {
  name_prefix = "prefect-agent"
  role        = var.iam_role_id == null ? aws_iam_role.role[0].name : var.iam_role_id
}

resource "aws_iam_role" "role" {
  count       = var.iam_role_id == null ? 1 : 0
  name_prefix = "prefect-agent"
  path        = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "policy" {
  count       = var.iam_role_id == null ? 1 : 0
  name_prefix = "prefect-agent"
  role        = var.iam_role_id == null ? aws_iam_role.role[0].name : var.iam_role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:Describe*",
          "ecr:Get*"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:ecr:*:${data.aws_caller_identity.current.account_id}:repository/*"]
      },
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListAllMyBuckets",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = data.aws_secretsmanager_secret.prefect.arn
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "ssm_policy" {
  count      = var.attach_ssm_policy ? 1 : 0
  name       = "ssm-policy-attachment"
  roles      = var.iam_role_id == null ? [aws_iam_role.role[0].name] : [var.iam_role_id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
