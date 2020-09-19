output "role_name" {
  value       = module.role.role_name
  description = "The name of the created role"
}

output "role_id" {
  value       = module.role.role_id
  description = "The stable and unique string identifying the role"
}

output "role_arn" {
  value       = module.role.role_arn
  description = "The Amazon Resource Name (ARN) specifying the role"
}

output "kms_key_arn" {
  value       = module.kms_key.key_arn
  description = "KMS key ARN"
}

output "kms_key_id" {
  value       = module.kms_key.key_id
  description = "KMS key ID"
}

output "kms_key_alias_arn" {
  value       = module.kms_key.alias_arn
  description = "KMS key alias ARN"
}

output "kms_key_alias_name" {
  value       = module.kms_key.alias_name
  description = "KMS key alias name"
}

output "bucket_domain_name" {
  value       = module.bucket.bucket_domain_name
  description = "FQDN of bucket"
}

output "bucket_id" {
  value       = module.bucket.bucket_id
  description = "Bucket Name (aka ID)"
}

output "bucket_arn" {
  value       = module.bucket.bucket_arn
  description = "Bucket ARN"
}
