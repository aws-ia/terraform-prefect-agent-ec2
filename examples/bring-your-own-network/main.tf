module "prefect" {
  source = "../../"

  key_name = var.key_name

  deploy_network = false
  vpc_id         = var.vpc_id
  subnet_ids     = var.subnet_ids
}
