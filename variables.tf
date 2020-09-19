variable "bucket_arn" {
  type        = string
  description = "ARN of S3 bucket"
}

variable "principals_arns" {
  type        = list(string)
  default     = []
  description = "List of ARNs to allow assuming the role. Could be AWS services or accounts, Kops nodes, IAM users or groups"
}

variable "services" {
  type        = list(string)
  default     = []
  description = "Names of chamber services"
}

variable "max_session_duration" {
  type        = number
  default     = 3600
  description = "The maximum session duration (in seconds) for the role. Can have a value from 1 hour to 12 hours"
}

variable "read_only" {
  type        = bool
  default     = false
  description = "Set to `true` to deny write actions for bucket"
}

variable "role_enabled" {
  type        = bool
  description = "Set to `false` to prevent the module from creating IAM role"
  default     = true
}

variable "role_description" {
  type        = string
  description = "The description of the IAM role that is visible in the IAM role manager"
  default     = "Role to access S3 bucket"
}

variable "policy_description" {
  type        = string
  description = "The description of the IAM policy that is visible in the IAM policy manager"
  default     = "Policy to access S3 bucket"
}
