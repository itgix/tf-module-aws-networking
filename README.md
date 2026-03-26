The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

# AWS Networking Terraform Module

This module creates a full VPC networking stack including public, private, transit gateway, and firewall subnets, NAT gateways, route tables, NACLs, VPC flow logs, and Route 53 Resolver query logging.

Part of the [ITGix AWS Landing Zone](https://itgix.com/itgix-landing-zone/).

## Resources Created

- VPC with optional IPv6 and DHCP options
- Public, private, transit gateway, and firewall subnets
- Internet Gateway and NAT Gateways
- Route tables with configurable routes (including TGW and firewall routes)
- Network ACLs (public, private)
- VPC Flow Logs (CloudWatch and/or S3)
- Route 53 Resolver query logging

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.0 |
| AWS provider | >= 5.20 |

## Key Inputs

> This module has **150+ variables**. The most commonly used are listed below. See `variables.tf` for the complete list.

### VPC

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `create_vpc` | Controls if VPC should be created | `bool` | `true` | no |
| `name` | Name used on all resources as identifier | `string` | `""` | no |
| `cidr` | IPv4 CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| `secondary_cidr_blocks` | Secondary CIDR blocks for the VPC | `list(string)` | `[]` | no |
| `azs` | List of availability zones | `list(string)` | `[]` | no |
| `enable_dns_hostnames` | Enable DNS hostnames in the VPC | `bool` | `true` | no |
| `enable_dns_support` | Enable DNS support in the VPC | `bool` | `true` | no |
| `enable_ipv6` | Request Amazon-provided IPv6 CIDR | `bool` | `false` | no |
| `tags` | Tags for all resources | `map(string)` | `{}` | no |
| `vpc_tags` | Additional tags for the VPC | `map(string)` | `{}` | no |

### Subnets

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `public_subnets` | List of public subnet CIDRs | `list(string)` | `[]` | no |
| `private_subnets` | List of private subnet CIDRs | `list(string)` | `[]` | no |
| `transit_gateway_subnets` | List of transit gateway subnet CIDRs | `list(string)` | `[]` | no |
| `map_public_ip_on_launch` | Auto-assign public IPs in public subnets | `bool` | `false` | no |
| `public_subnet_suffix` | Suffix for public subnet names | `string` | `"public"` | no |
| `private_subnet_suffix` | Suffix for private subnet names | `string` | `"private"` | no |

### NAT Gateway

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `enable_nat_gateway` | Provision NAT Gateways | `bool` | `false` | no |
| `single_nat_gateway` | Use a single NAT Gateway for all private subnets | `bool` | `false` | no |
| `one_nat_gateway_per_az` | One NAT Gateway per availability zone | `bool` | `false` | no |
| `reuse_nat_ips` | Use existing EIPs for NAT Gateways | `bool` | `false` | no |
| `external_nat_ip_ids` | List of EIP IDs to use for NAT Gateways | `list(string)` | `[]` | no |

### Transit Gateway Integration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `enable_transit_gateway_private_route` | Enable TGW route in private route tables | `bool` | `false` | no |
| `tgw_id_private_route` | Transit Gateway ID for private routes | `string` | `""` | no |
| `enable_transit_gateway_to_firewall_route` | Enable TGW-to-firewall routes | `bool` | `false` | no |
| `network_firewall_endpoints` | Network Firewall endpoint IDs | `list(string)` | `[]` | no |

### VPC Flow Logs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `enable_flow_log` | Enable VPC Flow Logs | `bool` | `false` | no |
| `flow_log_destination_type` | Destination type (cloud-watch-logs or s3) | `string` | `"cloud-watch-logs"` | no |
| `flow_log_cloudwatch_log_group_retention_in_days` | CloudWatch log retention in days | `number` | `null` | no |

### DHCP Options

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `enable_dhcp_options` | Enable custom DHCP options set | `bool` | `false` | no |
| `dhcp_options_domain_name` | DNS name for DHCP options | `string` | `""` | no |
| `dhcp_options_domain_name_servers` | DNS servers for DHCP options | `list(string)` | `["AmazonProvidedDNS"]` | no |

## Key Outputs

> This module has **71 outputs**. The most commonly used are listed below. See `outputs.tf` for the complete list.

| Name | Description |
|------|-------------|
| `vpc_id` | The ID of the VPC |
| `vpc_arn` | The ARN of the VPC |
| `vpc_cidr_block` | The CIDR block of the VPC |
| `public_subnets` | List of public subnet IDs |
| `private_subnets` | List of private subnet IDs |
| `transit_gateway_subnets` | List of transit gateway subnet IDs |
| `public_route_table_ids` | List of public route table IDs |
| `private_route_table_ids` | List of private route table IDs |
| `nat_public_ips` | List of NAT Gateway public IPs |
| `default_security_group_id` | ID of the default security group |

## Usage Example

```hcl
module "networking" {
  source = "path/to/tf-module-aws-networking"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

  public_subnets          = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets         = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  transit_gateway_subnets = ["10.0.21.0/28", "10.0.22.0/28", "10.0.23.0/28"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true

  enable_flow_log                = true
  flow_log_destination_type      = "cloud-watch-logs"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```
