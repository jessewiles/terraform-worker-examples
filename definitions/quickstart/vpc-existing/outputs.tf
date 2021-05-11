# unused, prevent terraform deprecation problems
variable "region" {}
variable "deployment" {}
variable "environment" {}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to use"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet_ids" "public" {
  vpc_id = var.vpc_id

  tags = {
    Tier = "public"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id

  tags = {
    Tier = "private"
  }
}


# required for terraform 12 to create the state, outputs changing
# alone will not trigger a plan change
resource "null_resource" "null" {
  triggers = {
    output_hash = md5(jsonencode(concat(
      tolist(data.aws_subnet_ids.public.ids),
      tolist(data.aws_subnet_ids.private.ids),
      tolist([var.vpc_id]))))
  }
}

output "public_subnets" {
  value = tolist(data.aws_subnet_ids.public.ids)
}

output "private_subnets" {
  value = tolist(data.aws_subnet_ids.private.ids)
}

output "vpc_id" {
  value = var.vpc_id
}
