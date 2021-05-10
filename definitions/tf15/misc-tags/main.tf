locals {
  tag_map = merge(
    {
      product     = "A Little Demo"
      deparment   = "TheFunGroup"
      region      = var.region
      deployment  = var.deployment
      environment = var.environment
  }, var.extra_tags)
}

resource "null_resource" "null" {
  triggers = {
    tagmap_hash = md5(jsonencode(local.tag_map))
  }
}
