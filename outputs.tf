output "role_name" {
  value       = module.role.name
  description = "The name of the IAM role created"
}

output "role_id" {
  value       = module.role.id
  description = "The stable and unique string identifying the role"
}

output "role_arn" {
  value       = module.role.arn
  description = "The Amazon Resource Name (ARN) specifying the role"
}

output "role_policy_document" {
  value       = module.role.policy
  description = "IAM policy to access chamber S3"
}
