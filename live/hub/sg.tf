module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = var.service
  description = "default security group"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = []

  egress_rules = ["https-443-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
}
