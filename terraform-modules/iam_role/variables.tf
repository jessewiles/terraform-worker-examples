variable "name" {
  type        = string
  description = "The name of the role. If omitted, Terraform will assign a random, unique name."
}

variable "policy" {
  type        = string
  description = "The policy document. This is a JSON formatted string."
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "The description of the role and the policy."
}

variable "max_session_duration" {
  default     = "3600"
  type        = string
  description = "The maximum session duration (in seconds) that you want to set for the specified role."
}

variable "force_detach_policies" {
  default     = false
  type        = bool
  description = "Specifies to force detaching any policies the role has before destroying it."
}

variable "assume_services" {
  type        = list(string)
  description = "A list of services to generate assume role policy for"
  default     = []
}

variable "assume_accounts" {
  type        = list(string)
  description = "A list of accounts to generate assume role policy for"
  default     = []
}


variable "path" {
  default     = "/"
  type        = string
  description = "Path in which to create the role and the policy."
}

variable "kms_arn" {
  default     = ""
  type        = string
  description = "Supply the ARN to a key to grant the role access to the key"
}

variable "kms_operations" {
  default     = ["Encrypt", "Decrypt", "GenerateDataKey", "DescribeKey", "ReEncryptFrom", "ReEncryptTo"]
  type        = list(string)
  description = "Supply operations allowed on the KMS key"
}

variable "tags" {
  type    = map(string)
  default = {}
}
