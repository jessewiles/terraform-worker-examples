data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  all_tags = merge(local.tags, var.extra_tags)
  public_subnets = length(var.public_subnets) > 0 ? var.public_subnets : [
    cidrsubnet(var.vpc_cidr, 6, 0),
    cidrsubnet(var.vpc_cidr, 6, 1),
    cidrsubnet(var.vpc_cidr, 6, 2),

  ]

  private_subnets = length(var.private_subnets) > 0 ? var.private_subnets : [
    cidrsubnet(var.vpc_cidr, 6, 9),
    cidrsubnet(var.vpc_cidr, 6, 10),
    cidrsubnet(var.vpc_cidr, 6, 11),

  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = var.deployment
  cidr = var.vpc_cidr

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

  private_subnet_tags = { "Tier" : "private" }
  public_subnet_tags  = { "Tier" : "public" }

  tags = local.all_tags
}
