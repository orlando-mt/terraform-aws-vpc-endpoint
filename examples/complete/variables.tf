variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC where the endpoints are created"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets for the Interface endpoints"
  type        = list(string)
}

variable "route_table_ids" {
  description = "Route tables for the Gateway endpoints"
  type        = list(string)
}

variable "eks_node_security_group_id" {
  description = "Security group allowed to reach the endpoints"
  type        = string
}
