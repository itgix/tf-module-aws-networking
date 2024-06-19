# Stateless Rule groups
resource "aws_networkfirewall_rule_group" "stateless_group" {
  count = length(var.stateless_rule_group) > 0 ? length(var.stateless_rule_group) : 0
  type  = "STATELESS"

  name        = var.stateless_rule_group[count.index]["name"]
  description = var.stateless_rule_group[count.index]["description"]
  capacity    = var.stateless_rule_group[count.index]["capacity"]

  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        dynamic "stateless_rule" {
          for_each = var.stateless_rule_group[count.index].rule_config
          content {
            priority = stateless_rule.value.priority
            rule_definition {
              actions = ["aws:${stateless_rule.value.actions["type"]}"]
              match_attributes {
                source {
                  address_definition = stateless_rule.value.source_ipaddress
                }
                destination {
                  address_definition = stateless_rule.value.destination_ipaddress
                }
                protocols = stateless_rule.value.protocols_number
              }
            }
          }
        }
      }
    }
  }

  tags = merge(var.tags)
}
