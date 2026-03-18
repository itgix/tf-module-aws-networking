locals {
  enable_r53_resolver_query_log = var.create_vpc && var.enable_r53_resolver_query_log
}

################################################################################
# Route 53 Resolver Query Log
################################################################################

resource "aws_cloudwatch_log_group" "r53_resolver_query_log" {
  count = local.enable_r53_resolver_query_log ? 1 : 0

  name              = "${var.r53_resolver_query_log_cw_log_group_name_prefix}${var.name}"
  retention_in_days = var.r53_resolver_query_log_cw_retention_in_days
  kms_key_id        = var.r53_resolver_query_log_cw_kms_key_id
  skip_destroy      = var.r53_resolver_query_log_cw_skip_destroy

  tags = merge(var.tags, var.r53_resolver_query_log_tags)
}

resource "aws_route53_resolver_query_log_config" "this" {
  count = local.enable_r53_resolver_query_log ? 1 : 0

  name            = "${var.name}-r53-resolver-query-log"
  destination_arn = aws_cloudwatch_log_group.r53_resolver_query_log[0].arn

  tags = merge(var.tags, var.r53_resolver_query_log_tags)
}

resource "aws_route53_resolver_query_log_config_association" "this" {
  count = local.enable_r53_resolver_query_log ? 1 : 0

  resolver_query_log_config_id = aws_route53_resolver_query_log_config.this[0].id
  resource_id                  = local.vpc_id
}
