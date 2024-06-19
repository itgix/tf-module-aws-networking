# Network firewall service
resource "aws_networkfirewall_firewall" "main" {
  name                = var.firewall_name
  firewall_policy_arn = aws_networkfirewall_firewall_policy.main.arn
  vpc_id              = var.vpc_id

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping
    content {
      subnet_id = subnet_mapping.value.subnet_id
    }
  }
  tags = merge(var.tags)
}

# Network Firewall Policy
resource "aws_networkfirewall_firewall_policy" "main" {
  name = var.firewall_name

  firewall_policy {
    stateless_default_actions          = ["aws:${var.stateless_default_actions}"]
    stateless_fragment_default_actions = ["aws:${var.stateless_fragment_default_actions}"]

    # Stateless Rule Group Reference
    dynamic "stateless_rule_group_reference" {
      for_each = local.this_stateless_group_arn
      content {
        # Priority is sequentially as per index in stateless_rule_group list 
        priority     = index(local.this_stateless_group_arn, stateless_rule_group_reference.value) + 1
        resource_arn = stateless_rule_group_reference.value
      }
    }

    # StateFul Rule Group Reference
    dynamic "stateful_rule_group_reference" {
      for_each = local.this_stateful_group_arn
      content {
        resource_arn = stateful_rule_group_reference.value
      }
    }
  }
  tags = merge(var.tags)
}
