locals {
  resources = formatlist("%s/%s/*", var.bucket_arn, var.services)
}

data "aws_iam_policy_document" "resource_readonly_access" {
  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    resources = local.resources

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketLocation",
      "s3:AbortMultipartUpload"
    ]
  }
}

data "aws_iam_policy_document" "resource_full_access" {
  statement {
    sid    = "FullAccess"
    effect = "Allow"

    resources = local.resources

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketLocation",
      "s3:AbortMultipartUpload"
    ]
  }
}

data "aws_iam_policy_document" "base" {
  statement {
    sid    = "BaseAccess"
    effect = "Allow"

    resources = [
      var.bucket_arn
    ]

    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions"
    ]
  }
}

module "role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.9.3"

  enabled = module.this.enabled && var.role_enabled ? true : false

  principals = {
    "AWS" : var.principals_arns
  }

  policy_documents = [
    var.read_only ? data.aws_iam_policy_document.resource_readonly_access.json : data.aws_iam_policy_document.resource_full_access.json,
    data.aws_iam_policy_document.base.json
  ]

  max_session_duration = var.max_session_duration
  role_description     = var.role_description
  policy_description   = var.policy_description

  context = module.this.context
}
