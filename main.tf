module "label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.1.3"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
  enabled    = "${var.enabled}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${var.principals_arns}"]
    }
  }
}

locals {
  resources = ["${formatlist("%s/%s/*", var.bucket_arn, var.services)}"]
}

data "aws_iam_policy_document" "resource_readonly_access" {
  statement {
    sid       = "ReadonlyAccess"
    effect    = "Allow"
    resources = ["${local.resources}"]

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
    resources = ["${local.resources}"]

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

data "aws_iam_policy_document" "default" {
  source_json = "${var.read_only == "true" ? data.aws_iam_policy_document.resource_readonly_access.json : data.aws_iam_policy_document.resource_full_access.json}"

  statement {
    sid = "BaseAccess"

    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions",
    ]

    resources = ["${var.bucket_arn}"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "default" {
  count       = "${var.enabled == "true" ? 1 : 0}"
  name        = "${module.label.id}"
  description = "Allow S3 actions"
  policy      = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_iam_role" "default" {
  count                = "${var.enabled == "true" ? 1 : 0}"
  name                 = "${module.label.id}"
  assume_role_policy   = "${data.aws_iam_policy_document.assume_role.json}"
  description          = "IAM Role with permissions to perform actions on S3 resources"
  max_session_duration = "${var.max_session_duration}"
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = "${var.enabled == "true" ? 1 : 0}"
  role       = "${aws_iam_role.default.name}"
  policy_arn = "${aws_iam_policy.default.arn}"
}
