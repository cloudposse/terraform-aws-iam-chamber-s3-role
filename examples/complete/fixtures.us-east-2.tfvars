enabled = true

region = "us-east-2"

namespace = "eg"

stage = "test"

name = "chamber-s3-role"

principals_arns = ["*"]

services = ["app", "staging", "default"]

read_only = false
