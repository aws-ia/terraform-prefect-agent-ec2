module "prefect" {
  source = "../../"

  prefect_api_key_secret_name = "prefect-api-key" #tfsec:ignore:general-secrets-no-plaintext-exposure tfsec:ignore:general-secrets-sensitive-in-attribute
  prefect_secret_key          = "key"             #tfsec:ignore:general-secrets-no-plaintext-exposure tfsec:ignore:general-secrets-sensitive-in-attribute

  prefect_labels          = "['prod']"
  agent_automation_config = var.agent_automation_config

  enable_local_flow_logs = true
}