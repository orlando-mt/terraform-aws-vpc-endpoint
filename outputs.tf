output "security_group_id" {
  description = "ID of the endpoints security group (null when not created)"
  value       = var.create_security_group ? aws_security_group.this[0].id : null
}

output "security_group_arn" {
  description = "ARN of the endpoints security group (null when not created)"
  value       = var.create_security_group ? aws_security_group.this[0].arn : null
}

output "interface_endpoints" {
  description = "Interface endpoints created, keyed by endpoint name"
  value = {
    for k, v in aws_vpc_endpoint.interface : k => {
      id                    = v.id
      arn                   = v.arn
      state                 = v.state
      service_name          = v.service_name
      dns_entries           = v.dns_entry
      network_interface_ids = v.network_interface_ids
    }
  }
}

output "gateway_endpoints" {
  description = "Gateway endpoints created, keyed by endpoint name"
  value = {
    for k, v in aws_vpc_endpoint.gateway : k => {
      id           = v.id
      arn          = v.arn
      state        = v.state
      service_name = v.service_name
    }
  }
}

output "endpoint_ids" {
  description = "IDs of all endpoints created"
  value = merge(
    { for k, v in aws_vpc_endpoint.interface : k => v.id },
    { for k, v in aws_vpc_endpoint.gateway : k => v.id }
  )
}

output "endpoint_arns" {
  description = "ARNs of all endpoints created"
  value = merge(
    { for k, v in aws_vpc_endpoint.interface : k => v.arn },
    { for k, v in aws_vpc_endpoint.gateway : k => v.arn }
  )
}

output "endpoint_dns_names" {
  description = "Primary DNS name of each Interface endpoint"
  value       = { for k, v in aws_vpc_endpoint.interface : k => tolist(v.dns_entry)[0].dns_name }
}
