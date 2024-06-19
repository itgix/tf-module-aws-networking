# Stateful Rule groups
resource "aws_networkfirewall_rule_group" "suricata_stateful_group" {
  count = length(var.suricata_stateful_rule_group) > 0 ? length(var.suricata_stateful_rule_group) : 0
  type  = "STATEFUL"

  name        = var.suricata_stateful_rule_group[count.index]["name"]
  description = var.suricata_stateful_rule_group[count.index]["description"]
  capacity    = var.suricata_stateful_rule_group[count.index]["capacity"]

  rule_group {
    dynamic "rule_variables" {
      for_each = var.suricata_stateful_rule_group[count.index].rule_variables
      content {
        ip_sets {
          key = rule_variables.value.key
          ip_set {
            definition = [rule_variables.value.ip_set]
          }
        }
      }
    }
    rules_source {
      rules_string = var.suricata_stateful_rule_group[count.index]["rules_file"]
    }
  }

  tags = merge(var.tags)
}

resource "aws_networkfirewall_rule_group" "domain_stateful_group" {
  count = length(var.domain_stateful_rule_group) > 0 ? length(var.domain_stateful_rule_group) : 0
  type  = "STATEFUL"

  name        = var.domain_stateful_rule_group[count.index]["name"]
  description = var.domain_stateful_rule_group[count.index]["description"]
  capacity    = var.domain_stateful_rule_group[count.index]["capacity"]

  rule_group {
    dynamic "rule_variables" {
      for_each = lookup(var.domain_stateful_rule_group[count.index], "rule_variables", [])
      content {
        ip_sets {
          key = rule_variables.value["key"]
          ip_set {
            definition = rule_variables.value["ip_set"]
          }
        }
      }
    }

    rules_source {
      rules_source_list {
        generated_rules_type = var.domain_stateful_rule_group[count.index]["actions"]
        target_types         = var.domain_stateful_rule_group[count.index]["protocols"]
        targets              = var.domain_stateful_rule_group[count.index]["domain_list"]
      }
    }
  }

  tags = merge(var.tags)
}

resource "aws_networkfirewall_rule_group" "fivetuple_stateful_group" {
  count = length(var.fivetuple_stateful_rule_group) > 0 ? length(var.fivetuple_stateful_rule_group) : 0
  type  = "STATEFUL"

  name        = var.fivetuple_stateful_rule_group[count.index]["name"]
  description = var.fivetuple_stateful_rule_group[count.index]["description"]
  capacity    = var.fivetuple_stateful_rule_group[count.index]["capacity"]

  rule_group {
    rules_source {
      dynamic "stateful_rule" {
        for_each = var.fivetuple_stateful_rule_group[count.index].rule_config
        content {
          action = upper(stateful_rule.value.actions["type"])
          header {
            destination      = stateful_rule.value.destination_ipaddress
            destination_port = stateful_rule.value.destination_port
            direction        = upper(stateful_rule.value.direction)
            protocol         = upper(stateful_rule.value.protocol)
            source           = stateful_rule.value.source_ipaddress
            source_port      = stateful_rule.value.source_port
          }
          rule_option {
            keyword = "sid:1"
          }
        }
      }
    }
  }

  tags = merge(var.tags)
}


