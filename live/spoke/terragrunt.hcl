include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = var.region

  assume_role {
    role_arn = format("arn:aws:iam::%v:role/OrganizationAccountAccessRole", var.spoke_account_id)
  }
}

provider "docker" {
  registry_auth {
    address  = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, var.region)
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}
EOF
}

# dependency "hub" {
#   config_path = "../hub"
#   mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
#   mock_outputs = {
#     ram_shared_resources = {
#       subnets        = ["subnet-00000000000000000"]
#       security_group = "sg-00000000000000000"
#     }
#   }
# }

terraform {
  source = "./"
}

inputs = {
  # private_subnets       = dependency.hub.outputs.ram_shared_resources.subnets
  # security_group        = [dependency.hub.outputs.ram_shared_resources.security_group]
  # create_security_group = dependency.hub.outputs.ram_shared_resources.security_group == "sg-00000000000000000" ? false : true
  spoke_account_id      = include.root.locals.variables.spoke_account_id
  ado                   = include.root.locals.variables.ado
  build_context         = "../../workloads/ado-agent"
}
