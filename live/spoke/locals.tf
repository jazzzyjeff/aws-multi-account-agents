locals {
  private_subnet_ids = [
    for arn in var.private_subnets :
    split("/", arn)[1]
  ]

  default_tags = {
    Name = var.service
  }
}
