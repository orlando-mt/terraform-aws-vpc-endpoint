data "aws_region" "current" {}

locals {
  enabled_endpoints = { for k, v in var.endpoints : k => v if v.enabled }

  interface_endpoints = { for k, v in local.enabled_endpoints : k => v if v.type == "Interface" }
  gateway_endpoints   = { for k, v in local.enabled_endpoints : k => v if v.type == "Gateway" }

  # Short service names ("ecr.api") expand to the full regional service name.
  # Fully qualified names ("com.amazonaws.us-east-1.s3") are used as-is.
  service_names = {
    for k, v in local.enabled_endpoints : k => (
      startswith(v.service_name, "com.amazonaws.")
      ? v.service_name
      : "com.amazonaws.${data.aws_region.current.region}.${v.service_name}"
    )
  }

  security_group_id = var.create_security_group ? aws_security_group.this[0].id : var.existing_security_group_id
}

# ---------------------------------------------------------------------------
# Interface endpoints (ENIs in the given subnets, reached over HTTPS)
# ---------------------------------------------------------------------------

resource "aws_vpc_endpoint" "interface" {
  for_each = local.interface_endpoints

  vpc_id              = var.vpc_id
  service_name        = local.service_names[each.key]
  vpc_endpoint_type   = "Interface"
  subnet_ids          = coalesce(each.value.subnet_ids, var.subnet_ids)
  security_group_ids  = [local.security_group_id]
  private_dns_enabled = each.value.private_dns_enabled
  policy              = each.value.policy

  tags = merge(
    var.tags,
    each.value.tags,
    {
      Name        = "${var.name_prefix}-${each.key}"
      Environment = var.environment
      Type        = "Interface"
    }
  )
}

# ---------------------------------------------------------------------------
# Gateway endpoints (route table entries; S3 and DynamoDB only)
# ---------------------------------------------------------------------------

resource "aws_vpc_endpoint" "gateway" {
  for_each = local.gateway_endpoints

  vpc_id            = var.vpc_id
  service_name      = local.service_names[each.key]
  vpc_endpoint_type = "Gateway"
  route_table_ids   = coalesce(each.value.route_table_ids, var.route_table_ids)
  policy            = each.value.policy

  tags = merge(
    var.tags,
    each.value.tags,
    {
      Name        = "${var.name_prefix}-${each.key}"
      Environment = var.environment
      Type        = "Gateway"
    }
  )
}
