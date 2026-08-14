variable "vpc_id" {
  description = "ID of the VPC where the endpoints will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC, used to scope the security group egress rule"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}

variable "endpoints" {
  description = <<-EOT
    Map of VPC endpoints to create. Each entry supports:
      - service_name (required): short name ("ecr.api", "s3") expanded to the
        current region, or a fully qualified name ("com.amazonaws.us-east-1.s3").
      - type (required): "Interface" or "Gateway" (Gateway only for s3/dynamodb).
      - private_dns_enabled (optional, true): Interface endpoints only.
      - subnet_ids / route_table_ids (optional): per-endpoint override of the
        module-level defaults.
      - policy (optional): endpoint policy JSON restricting what can be accessed.
      - enabled (optional, true): skip creation without removing the definition.
      - tags (optional): per-endpoint tags.
  EOT
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
  default = {}

  validation {
    condition     = alltrue([for e in var.endpoints : contains(["Interface", "Gateway"], e.type)])
    error_message = "endpoint type must be \"Interface\" or \"Gateway\"."
  }

  validation {
    condition = alltrue([
      for e in var.endpoints :
      e.type != "Gateway" || can(regex("(s3|dynamodb)$", e.service_name))
    ])
    error_message = "Gateway endpoints are only supported for s3 and dynamodb."
  }
}

variable "subnet_ids" {
  description = "Default subnet IDs for Interface endpoints (one per AZ recommended)"
  type        = list(string)
  default     = []
}

variable "route_table_ids" {
  description = "Default route table IDs for Gateway endpoints"
  type        = list(string)
  default     = []
}

# --- Security group --------------------------------------------------------

variable "create_security_group" {
  description = "Create a security group for the Interface endpoints"
  type        = bool
  default     = true
}

variable "existing_security_group_id" {
  description = "Existing security group ID for Interface endpoints (used when create_security_group is false)"
  type        = string
  default     = null

  validation {
    condition     = var.create_security_group || var.existing_security_group_id != null
    error_message = "existing_security_group_id is required when create_security_group is false."
  }
}

variable "allowed_security_group_ids" {
  description = "Security group IDs allowed to reach the endpoints over HTTPS (e.g. EKS node security group)"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the endpoints over HTTPS"
  type        = list(string)
  default     = []
}

# --- Naming and tags -------------------------------------------------------

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
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
