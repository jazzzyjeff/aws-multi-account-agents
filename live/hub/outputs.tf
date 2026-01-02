output "ram_shared_resources" {
  value = {
    subnets        = module.vpc.private_subnet_arns
    security_group = module.sg.security_group_arn
  }
}
