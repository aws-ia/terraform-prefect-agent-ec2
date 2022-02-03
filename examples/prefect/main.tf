module "prefect" {
  source = "../../"

  instance_type = "t2.medium"
  key_name      = var.key_name

  custom_tags = {
    "environment" : "prod"
  }

  prefect_api_key_secret_name = "prefect-api-key" #tfsec:ignore:general-secrets-no-plaintext-exposure
  prefect_secret_key          = "key"             #tfsec:ignore:general-secrets-no-plaintext-exposure
  prefect_labels              = "['prod']"

  deploy_network = false
  vpc_id         = var.vpc_id
  subnet_ids     = var.subnet_ids
}