variable "region" {
  type        = string
  description = "AWS region"
}

variable "principals_arns" {
  type        = list(string)
  description = "List of ARNs to allow assuming the role. Could be AWS services or accounts, Kops nodes, IAM users or groups"
}

variable "services" {
  type        = list(string)
  description = "Names of chamber services"
}

variable "read_only" {
  type        = bool
  description = "Set to `true` to deny write actions for bucket"
}
