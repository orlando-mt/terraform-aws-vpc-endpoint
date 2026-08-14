region      = "us-east-1"
name_prefix = "example"
environment = "dev"

vpc_id   = "vpc-00000000000000000"
vpc_cidr = "10.20.0.0/16"

subnet_ids      = ["subnet-00000000000000001", "subnet-00000000000000002", "subnet-00000000000000003"]
route_table_ids = ["rtb-00000000000000000"]

# Endpoint set typically needed by EKS nodes in private subnets with no NAT.
# Service names are short: the module expands them to the current region.
endpoints = {
  # Gateway endpoints: free, route-table based
  s3 = {
    service_name = "s3"
    type         = "Gateway"
  }
  dynamodb = {
    service_name = "dynamodb"
    type         = "Gateway"
  }

  # Interface endpoints: one ENI per subnet, billed hourly
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

# Only the EKS nodes may reach the endpoints
allowed_security_group_ids = ["sg-00000000000000000"]

tags = {
  Project   = "example"
  ManagedBy = "terraform"
}
