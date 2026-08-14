variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC where the endpoints are created"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR of the VPC (scopes the security group egress)"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnets for the Interface endpoints"
  type        = list(string)
}

variable "route_table_ids" {
  description = "Route tables for the Gateway endpoints"
  type        = list(string)
}

variable "endpoints" {
  description = "Endpoints to create"
  type = map(object({
    service_name        = string
    type                = string
    private_dns_enabled = optional(bool, true)
    subnet_ids          = optional(list(string))
    route_table_ids     = optional(list(string))
    policy              = optional(string)
    enabled             = optional(bool, true)
    tags                = optional(map(string), {})
  }))
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to reach the endpoints over HTTPS"
  type        = list(string)
  default     = []
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "vpc-endpoint"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
