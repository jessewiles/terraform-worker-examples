# global worker variables
variable "deployment" {}
variable "region" {}
variable "environment" {}

variable "name" {
  type        = string
  description = "The name of this deployment"
}

variable "extra_tags" {
  type        = map(string)
  description = "Extra tags to apply to instance"
  default     = {}
}

variable "ami_name" {
  type        = string
  description = "The AMI name to filter for creation"
  default     = "ubuntu/images/*/ubuntu-groovy-*-amd64-server-*"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to launch"
  default     = "t2.micro"
}

variable "public_ip" {
  type        = bool
  description = "Should a public IP be associated with this image?"
  default     = false
}
