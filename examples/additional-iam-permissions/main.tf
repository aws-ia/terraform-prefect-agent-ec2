module "prefect" {
  source = "../../"
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
