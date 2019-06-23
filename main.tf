locals {
  resources = formatlist("%s/%s/*", var.bucket_arn, var.services)
}

data "aws_iam_policy_document" "resource_readonly_access" {
  statement {
    sid       = "ReadonlyAccess"
    effect    = "Allow"
    resources = local.resources

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketLocation",
      "s3:AbortMultipartUpload",
    ]
  }
}

data "aws_iam_policy_document" "resource_full_access" {
  statement {
    sid       = "FullAccess"
    effect    = "Allow"
    resources = local.resources

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketLocation",
      "s3:AbortMultipartUpload",
    ]
  }
}

data "aws_iam_policy_document" "base" {
  statement {
    sid = "BaseAccess"

    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions",
    ]

    resources = [var.bucket_arn]
    effect    = "Allow"
  }
}

module "role" {
  source = "git::https://github.com/rverma-nikiai/terraform-aws-iam-role.git?ref=master"

  enabled    = var.enabled == "true" && var.role_enabled == "true" ? "true" : "false"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
  delimiter  = var.delimiter
  tags       = var.tags

  principals_arns = var.principals_arns

  policy_documents = [
    var.read_only == "true" ? data.aws_iam_policy_document.resource_readonly_access.json : data.aws_iam_policy_document.resource_full_access.json,
    data.aws_iam_policy_document.base.json,
  ]

  max_session_duration = var.max_session_duration
  role_description     = var.role_description
  policy_description   = var.policy_description
}

