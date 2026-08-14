# terraform-aws-vpc-endpoint

Terraform module to create AWS VPC endpoints (Interface and Gateway) from a single map definition, with an optional shared security group.

## Features

- Interface and Gateway endpoints declared together in one `endpoints` map
- **Short service names** (`ecr.api`, `s3`, `logs`) automatically expanded to the current region — no hardcoded `com.amazonaws.<region>.<service>` strings; fully qualified names are also accepted
- Per-endpoint overrides: subnets, route tables, endpoint policy and tags
- Optional security group for Interface endpoints: HTTPS ingress from allowed security groups and/or CIDRs, **egress scoped to the VPC CIDR** instead of the whole internet
- `enabled` flag per endpoint to toggle creation without deleting the definition
- Validations: endpoint type, Gateway restricted to S3/DynamoDB, security group requirements

## Usage

```hcl
module "vpc_endpoints" {
  source = "github.com/orlando-mt/terraform-aws-vpc-endpoint?ref=v1.0.0"

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr_block

  subnet_ids      = module.vpc.private_subnet_ids_by_service["eks"]
  route_table_ids = values(module.vpc.private_route_table_ids)

  endpoints = {
    s3      = { service_name = "s3", type = "Gateway" }
    ecr_api = { service_name = "ecr.api", type = "Interface" }
    ecr_dkr = { service_name = "ecr.dkr", type = "Interface" }
    logs    = { service_name = "logs", type = "Interface" }
    sts     = { service_name = "sts", type = "Interface" }
  }

  allowed_security_group_ids = [module.eks.node_security_group_id]

  name_prefix = "my-project"
  environment = "prod"
}
```

> **Cost note:** Gateway endpoints (S3, DynamoDB) are free and work through route tables. Interface endpoints create an ENI per subnet and are billed hourly per ENI plus data processed — deploy them only in the subnets that need them, and prefer Gateway endpoints where available.

> **Tip:** pairs with [terraform-aws-vpc](https://github.com/orlando-mt/terraform-aws-vpc), whose `private_subnet_ids_by_service` and `private_route_table_ids` outputs feed this module directly. This is what lets private subnets reach AWS services without a NAT gateway.

## Examples

- [Complete](./examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| aws | >= 5.0 |

## Resources

| Name | Type |
|------|------|
| aws_vpc_endpoint.interface | resource |
| aws_vpc_endpoint.gateway | resource |
| aws_security_group.this | resource |
| aws_vpc_security_group_ingress_rule.from_security_groups | resource |
| aws_vpc_security_group_ingress_rule.from_cidr_blocks | resource |
| aws_vpc_security_group_egress_rule.to_vpc | resource |
| aws_region.current | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | VPC ID | `string` | n/a | yes |
| vpc_cidr | VPC CIDR (scopes SG egress) | `string` | n/a | yes |
| endpoints | Map of endpoints to create | `map(object)` | `{}` | no |
| subnet_ids | Default subnets for Interface endpoints | `list(string)` | `[]` | no |
| route_table_ids | Default route tables for Gateway endpoints | `list(string)` | `[]` | no |
| create_security_group | Create the endpoints SG | `bool` | `true` | no |
| existing_security_group_id | Existing SG to use instead | `string` | `null` | no |
| allowed_security_group_ids | SGs allowed over HTTPS | `list(string)` | `[]` | no |
| allowed_cidr_blocks | CIDRs allowed over HTTPS | `list(string)` | `[]` | no |
| name_prefix | Prefix for resource names | `string` | `"vpc-endpoint"` | no |
| environment | Environment name | `string` | `"dev"` | no |
| tags | Tags for all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id / security_group_arn | Endpoints security group |
| interface_endpoints | Interface endpoint details |
| gateway_endpoints | Gateway endpoint details |
| endpoint_ids / endpoint_arns | All endpoints |
| endpoint_dns_names | Primary DNS name per Interface endpoint |
<!-- END_TF_DOCS -->

## License

MIT. See [LICENSE](./LICENSE).
