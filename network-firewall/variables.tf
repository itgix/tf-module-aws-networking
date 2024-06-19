variable "fivetuple_stateful_rule_group" {
  description = "Config for 5-tuple type stateful rule group"
  type        = list(any)
  default     = []
}

variable "domain_stateful_rule_group" {
  description = "Config for domain type stateful rule group"
  type        = list(any)
  default     = []
}

variable "suricata_stateful_rule_group" {
  description = "Config for Suricata type stateful rule group"
  type        = list(any)
  default     = []
}

variable "stateless_rule_group" {
  description = "Config for stateless rule group"
  type        = list(any)
}

variable "firewall_name" {
  description = "firewall name"
  type        = string
  default     = "example"
}

variable "subnet_mapping" {
  description = "Subnet ids mapping to have individual firewall endpoint"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}

variable "stateless_default_actions" {
  description = "Default stateless Action"
  type        = string
  default     = "forward_to_sfe"
}

variable "stateless_fragment_default_actions" {
  description = "Default Stateless action for fragmented packets"
  type        = string
  default     = "forward_to_sfe"
}


# Logging
variable "netfw_cloudwatch_logs_enabled" {
  description = "Weather to enable Cloudwatch logs for Network firewall"
  type        = bool
  default     = false
}

variable "netfw_s3_logs_enabled" {
  description = "Weather to enable S3 logs for Network firewall"
  type        = bool
  default     = false
}

variable "netfw_kinesis_logs_enabled" {
  description = "Weather to enable Kinesis Data Firehose for sending Network firewall logs"
  type        = bool
  default     = false
}

variable "netfw_cloudwatch_log_group_name" {
  description = "Name of the Cloudwatch log group to be used for Network firewall logs"
  type        = string
}

variable "netfw_log_type" {
  description = "Type of logs to be enabled on Networkfirewall - supported options are ALERT and FLOW"
  type        = string
  default     = "ALERT"
}

variable "netfw_s3_log_bucket_name" {
  description = "Name of the S3 bucket to store logs"
  type        = string
  default     = "netfw_logs"
}

variable "netfw_kinesis_firehose_delivery_stream" {
  description = "Name of Kinesis Data Firehose to be used for Network Firewall logs"
  type        = string
  default     = ""
}
