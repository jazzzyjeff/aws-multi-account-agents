output "subnets" {
  value = [for arn in module.vpc.private_subnet_arns : element(split("/", arn), length(split("/", arn)) - 1)]
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
