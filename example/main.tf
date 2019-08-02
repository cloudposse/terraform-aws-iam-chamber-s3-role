module "kms_key" {
  source    = "git::https://github.com/cloudposse/terraform-aws-kms-key.git?ref=0.11/master"
  namespace = "cp"
  stage     = "prod"
  name      = "app"

  tags = {
    ManagedBy = "Terraform"
  }

  description             = "KMS key for Parameter Store"
  deletion_window_in_days = 10
  enable_key_rotation     = "true"
  alias                   = "alias/parameter_store_key"
}

module "bucket" {
  source  = "git::https://github.com/cloudposse/terraform-aws-s3-bucket.git?ref=0.11/master"
  enabled = "true"

  namespace = "cp"
  stage     = "prod"
  name      = "chamber"

  tags = {
    ManagedBy = "Terraform"
  }

  versioning_enabled = "false"
  user_enabled       = "false"

  sse_algorithm     = "aws:kms"
  kms_master_key_arn = "${module.kms_key.key_arn}"
}

module "app" {
  source = "../"

  namespace = "cp"
  stage     = "prod"
  name      = "app"

  tags = {
    ManagedBy = "Terraform"
  }

  principals_arns = []

  bucket_arn = "${module.bucket.bucket_arn}"

  services = ["app", "staging", "default"]
}
