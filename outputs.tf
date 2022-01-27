output "prefect_role_id" {
  value       = var.iam_role_id == null ? aws_iam_role.role[0].name : null
  description = "iam role id of the role attached to the prefect launch template"
}