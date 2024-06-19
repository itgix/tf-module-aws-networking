data "aws_default_tags" "current" {}

# Logging 

# Cloudwatch log groups
resource "aws_networkfirewall_logging_configuration" "cloudwatch_log_group" {
  count        = var.netfw_cloudwatch_logs_enabled == true ? 1 : 0
  firewall_arn = aws_networkfirewall_firewall.main.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = var.netfw_cloudwatch_log_group_name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = var.netfw_log_type
    }
  }
}

resource "aws_cloudwatch_log_group" "netfw_cloudwatch_logs" {
  count = var.netfw_cloudwatch_logs_enabled == true ? 1 : 0
  name  = var.netfw_cloudwatch_log_group_name

  tags = merge(var.tags)
}

# TODO: S3 and Kinesis firehose are not tested
# S3
resource "aws_networkfirewall_logging_configuration" "s3_logging" {
  count        = var.netfw_s3_logs_enabled == true ? 1 : 0
  firewall_arn = aws_networkfirewall_firewall.main.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        bucketName = var.netfw_s3_log_bucket_name
        prefix     = "/netfw"
      }
      log_destination_type = "S3"
      log_type             = var.netfw_log_type
    }
  }
}

# Kinesis Data Firehose
resource "aws_networkfirewall_logging_configuration" "kinesis_logging" {
  count        = var.netfw_kinesis_logs_enabled == true ? 1 : 0
  firewall_arn = aws_networkfirewall_firewall.main.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        deliveryStream = var.netfw_kinesis_firehose_delivery_stream
      }
      log_destination_type = "KinesisDataFirehose"
      log_type             = var.netfw_log_type
    }
  }
}
