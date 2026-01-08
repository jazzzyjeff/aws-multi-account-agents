resource "aws_ram_resource_share" "this" {
  name                      = var.service
  allow_external_principals = false

  tags = local.default_tags

  depends_on = [aws_ram_sharing_with_organization.this]
}

resource "aws_ram_sharing_with_organization" "this" {}

resource "aws_ram_resource_association" "subnets" {
  for_each = {
    for idx, arn in module.vpc.private_subnet_arns :
    idx => arn
  }
  resource_arn       = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}

resource "aws_ram_principal_association" "this" {
  principal          = data.aws_organizations_organization.this.arn
  resource_share_arn = aws_ram_resource_share.this.arn
}
