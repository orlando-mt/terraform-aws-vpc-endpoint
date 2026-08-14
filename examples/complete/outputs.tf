output "endpoint_ids" {
  description = "IDs of all endpoints created"
  value       = module.vpc_endpoints.endpoint_ids
}

output "endpoint_dns_names" {
  description = "DNS names of the Interface endpoints"
  value       = module.vpc_endpoints.endpoint_dns_names
}
