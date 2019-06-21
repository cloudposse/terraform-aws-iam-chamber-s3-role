module "kms_key" {
  source    = "git::https://github.com/rverma-nikiai/terraform-aws-kms-key.git?ref=master"
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
  source  = "git::https://github.com/rverma-nikiai/terraform-aws-s3-bucket.git?ref=master"
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
  kms_master_key_id = "${module.kms_key.key_id}"
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
