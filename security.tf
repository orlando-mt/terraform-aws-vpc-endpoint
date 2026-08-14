resource "aws_security_group" "this" {
  count = var.create_security_group ? 1 : 0

  name_prefix = "${var.name_prefix}-"
  vpc_id      = var.vpc_id
  description = "Security group for VPC interface endpoints"

  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-sg"
      Environment = var.environment
      Purpose     = "vpc-endpoints"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "from_security_groups" {
  for_each = var.create_security_group ? toset(var.allowed_security_group_ids) : []

  security_group_id            = aws_security_group.this[0].id
  description                  = "Allow HTTPS from ${each.value}"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = each.value

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "from_cidr_blocks" {
  for_each = var.create_security_group ? toset(var.allowed_cidr_blocks) : []

  security_group_id = aws_security_group.this[0].id
  description       = "Allow HTTPS from ${each.value}"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value

  tags = var.tags
}

# Endpoints only need to reply to callers inside the VPC; egress is scoped to
# the VPC CIDR instead of 0.0.0.0/0.
resource "aws_vpc_security_group_egress_rule" "to_vpc" {
  count = var.create_security_group ? 1 : 0

  security_group_id = aws_security_group.this[0].id
  description       = "Allow outbound traffic within the VPC"
  ip_protocol       = "-1"
  cidr_ipv4         = var.vpc_cidr

  tags = var.tags
}
