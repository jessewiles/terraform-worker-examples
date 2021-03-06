# a random password is generated for the wordpress database
# an example of how terraform resources can provide value to 
# cloudformation stacks deployed via terraform
resource "random_password" "db_password" {
  length      = 24
  lower       = true
  number      = true
  upper       = true
  min_lower   = 3
  min_upper   = 3
  min_numeric = 3
  special     = false
}

# an aws keypair can not be created via cloud formation, this definition
# leverages hook scripts to create a key, and then populate it within AWS
# this demonstrates the value of blending terraform with cloud formation
resource "aws_key_pair" "wordpress" {
  key_name   = format("%s-wordpress", var.deployment)
  public_key = file("/tmp/tf_wordpress_ssh_key.pub")
  tags       = local.tags
}

resource "aws_cloudformation_stack" "wordpress" {
  name = format("%s-wordpress", var.deployment)

  # there are many more optional params in the cloud formation template
  # these are the only ones that are required
  # some values such as vpc's and subnets are supplied by our existing
  # terraform modules, further demonstrating the value of deploying cloud
  # formation via terraform, we can leverage and re-use existing modules, 
  # and with the worker, feed their values straight into the cloud formation
  # template
  parameters = {
    "VpcId"        = local.vpc_id
    # even though the CloudFormation params specify this value should be a "list", 
    # that apparently means strings separated by commas
    "Subnets"      = join(",", local.subnets)
    "KeyName"      = aws_key_pair.wordpress.key_name
    "InstanceType" = var.instance_type
    # deployment should be further sanitized to work with AWS constraints
    "DBName"       = format("WP%s", replace(var.deployment, "-", ""))
    "DBUser"       = "wordpress"
    "DBPassword"   = random_password.db_password.result
  }

  # template body for the sake of this example, and keeping it all in a 
  # single repo is read in as a file. However, template_body could be omitted
  # and a remote URL could be used instead, for example, this comes from:
  # template_url = "https://s3.eu-west-1.amazonaws.com/cloudformation-templates-eu-west-1/WordPress_Multi_AZ.template"
  # however, the remote template does not actually work as it creates the DB outside of 
  # the VPC, and then tries to use security groups within a VPC resulting in the error:
  # "The DB instance and EC2 security group are in different VPCs. The DB instance is in ${A} and the EC2 security group is in ${Z}
  template_body = file("templates/WordPress_Multi_AZ.template")
  tags          = local.tags
}
