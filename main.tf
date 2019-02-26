module "label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.1.3"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
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
      identifiers = ["${var.assume_role_arns}"]
    }
  }
}

locals {
  write_access_bucket_actions = ["s3:PutObject", "s3:PutObjectAcl", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:GetBucketLocation", "s3:AbortMultipartUpload"]
  read_only_bucket_actions    = ["s3:GetObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:GetBucketLocation", "s3:AbortMultipartUpload"]
}

data "aws_iam_policy_document" "default" {
  statement {
    actions   = ["${split(" ", var.read_only == "true" ? join(" ", local.read_only_bucket_actions) : join(" ", local.write_access_bucket_actions))}"]
    resources = ["${formatlist("%s/%s/*", var.s3_bucket_arn, var.services)}"]
    effect    = "Allow"
  }

  statement {
    actions   = ["s3:ListBucket", "s3:ListBucketVersions"]
    resources = ["${var.s3_bucket_arn}"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "default" {
  name        = "${module.label.id}"
  description = "Allow S3 actions"
  policy      = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_iam_role" "default" {
  name                 = "${module.label.id}"
  assume_role_policy   = "${data.aws_iam_policy_document.assume_role.json}"
  description          = "IAM Role with permissions to perform actions on S3 resources"
  max_session_duration = "${var.max_session_duration}"
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = "${aws_iam_policy.default.arn}"
}
