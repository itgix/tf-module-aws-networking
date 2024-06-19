resource "aws_ram_resource_share" "this" {
  name = var.aws_ram_resource_share_name
  tags = var.tags

  allow_external_principals = var.allow_external_principals
}

resource "aws_ram_resource_association" "this" {
  resource_arn       = var.resource_arn
  resource_share_arn = aws_ram_resource_share.this.arn
}

resource "aws_ram_principal_association" "this" {
  principal          = var.principal
  resource_share_arn = aws_ram_resource_share.this.arn

}