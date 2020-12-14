data "aws_ami" "service" {
  most_recent = true
  owners      = ["amazon", "aws-marketplace"]

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

locals {
  prod_modifier = var.environment == "prod" ? 2 : 1
}

module "service" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.15.0"

  name                        = format("%s-%s", var.deployment, var.name)
  ami                         = data.aws_ami.service.id
  instance_type               = var.instance_type
  instance_count              = length(local.subnets) * local.prod_modifier
  associate_public_ip_address = false
  subnet_ids                  = local.subnets


  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 10
    },
  ]

  tags = merge(local.tags, var.extra_tags, { "service" : var.name })

}
