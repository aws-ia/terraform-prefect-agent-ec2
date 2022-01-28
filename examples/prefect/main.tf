module "prefect" {
  source = "../../"

  instance_type = "t3.medium"
  key_name      = "prefect.pem"

  custom_tags = {
    "environment" : "prod"
  }

  prefect_api_key_secret_name = "prefect-api-key"
  prefect_secret_key          = "key"
  prefect_labels              = "['prod']"

  deploy_network = false
  vpc_id         = "vpc-xxxxxxxxxxxxxxxxx"
  subnet_ids     = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxxxx"]

  ami_id = "somethinghere"
}