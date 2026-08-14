provider "aws" {
  region = var.region
}

module "vpc_endpoints" {
  source = "../../"

  vpc_id   = var.vpc_id
  vpc_cidr = var.vpc_cidr

  subnet_ids      = var.subnet_ids
  route_table_ids = var.route_table_ids

  endpoints = var.endpoints

  allowed_security_group_ids = var.allowed_security_group_ids

  name_prefix = var.name_prefix
  environment = var.environment

  tags = var.tags
}
