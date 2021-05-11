variable "region" {
  type        = string
  description = "The region the deployment is in, automatically provided to all modules"
}

variable "deployment" {
  type        = string
  description = "The name of the deployment, automatically provided to all modules"
}

variable "environment" {
  type        = string
  description = "The environment this deployment is for (i.e., dev, qa, prod )"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block to use for this VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = list
  description = "a list of the three public subnet CIDR's to use"
  default     = []
}

variable "private_subnets" {
  type        = list
  description = "a list of the three private subnet CIDR's to use"
  default     = []
}

variable "extra_tags" {
  type        = map(string)
  description = "Extra tags to apply to this resource"
  default     = {}
}
