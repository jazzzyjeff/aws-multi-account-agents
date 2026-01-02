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
}
EOF
}

terraform {
  source = "./"
}
