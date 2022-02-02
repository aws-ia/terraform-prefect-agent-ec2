module "prefect" {
  source = "../../"

  instance_type = "t2.medium"
  key_name      = var.key_name

  custom_tags = {
    "environment" : "prod"
  }

  prefect_api_key_secret_name = "prefect-api-key"
  prefect_secret_key          = "key"
  prefect_labels              = "['prod']"

  deploy_network = true
  vpc_cidr       = var.vpc_cidr
}