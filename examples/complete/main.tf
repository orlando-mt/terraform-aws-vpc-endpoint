provider "aws" {
  region = var.region
}

module "vpc_endpoints" {
  source = "../../"

  vpc_id   = var.vpc_id
  vpc_cidr = var.vpc_cidr

  subnet_ids      = var.private_subnet_ids
  route_table_ids = var.route_table_ids

  endpoints = {
    # Gateway endpoints (no ENI, no cost)
    s3 = {
      service_name = "s3"
      type         = "Gateway"
    }
    dynamodb = {
      service_name = "dynamodb"
      type         = "Gateway"
    }

    # Interface endpoints commonly needed by EKS nodes in private subnets
    ecr_api = {
      service_name = "ecr.api"
      type         = "Interface"
    }
    ecr_dkr = {
      service_name = "ecr.dkr"
      type         = "Interface"
    }
    logs = {
      service_name = "logs"
      type         = "Interface"
    }
    sts = {
      service_name = "sts"
      type         = "Interface"
    }
    secretsmanager = {
      service_name = "secretsmanager"
      type         = "Interface"
    }
  }

  allowed_security_group_ids = [var.eks_node_security_group_id]

  name_prefix = "example"
  environment = "dev"

  tags = {
    Project   = "example"
    ManagedBy = "terraform"
  }
}
