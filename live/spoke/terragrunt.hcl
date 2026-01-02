include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "${include.root.locals.region}"

  assume_role {
    role_arn = "arn:aws:iam::${include.root.locals.spoke_account_id}:role/OrganizationAccountAccessRole"
  }
}
EOF
}

dependency "hub" {
  config_path = "../hub"
  mock_outputs = {
    ram_shared_resources = {
      security_group = ""
      subnets = [""]
    }
  }
}

terraform {
  source = "./"
}

inputs = {
  private_subnets = dependency.hub.outputs.ram_shared_resources.subnets
  security_group = dependency.hub.outputs.ram_shared_resources.security_group
}