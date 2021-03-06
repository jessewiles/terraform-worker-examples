# inputs
variable "deployment" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

# optional inputs
variable "instance_type" {
  type    = string
  default = "t2.small"
}
