module "prefect" {
  source = "../../"

  instance_type = "t2.medium"
  key_name      = var.key_name

  custom_tags = {
    "environment" : "prod"
  }

  prefect_api_key_secret_name = "prefect-api-key" #tfsec:ignore:general-secrets-no-plaintext-exposure tfsec:ignore:general-secrets-sensitive-in-attribute
  prefect_secret_key          = "key"             #tfsec:ignore:general-secrets-no-plaintext-exposure tfsec:ignore:general-secrets-sensitive-in-attribute
  prefect_labels              = "['prod']"

  deploy_network = true
  vpc_cidr       = var.vpc_cidr
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "additional_policy" {
  name_prefix = "prefect-agent-additional"
  role        = module.prefect.prefect_role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:Batch*"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:ecr:*:${data.aws_caller_identity.current.account_id}:repository/*"]
      },
    ]
  })
}
