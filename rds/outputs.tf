output "db_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  #value       = local.password
  value       = nonsensitive(local.password)
 # sensitive   = true
}