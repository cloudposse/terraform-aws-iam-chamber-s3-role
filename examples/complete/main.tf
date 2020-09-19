provider "aws" {
  region = var.region
}

module "kms_key" {
  source = "git::https://github.com/cloudposse/terraform-aws-kms-key.git?ref=tags/0.7.0"

  description             = "Test KMS key"
  deletion_window_in_days = 7
  enable_key_rotation     = false

  context = module.this.context
}

module "bucket" {
  source = "git::https://github.com/cloudposse/terraform-aws-s3-bucket.git?ref=tags/0.22.0"

  user_enabled                 = false
  versioning_enabled           = false
  force_destroy                = true
  allow_encrypted_uploads_only = true
  sse_algorithm                = "aws:kms"
  kms_master_key_arn           = module.kms_key.key_arn

  context = module.this.context
}

module "role" {
  source = "../../"

  principals_arns    = var.principals_arns
  read_only          = var.read_only
  bucket_arn         = module.bucket.bucket_arn
  services           = var.services
  role_description   = "Test role for chamber"
  policy_description = "Test policy for chamber"

  context = module.this.context
}
