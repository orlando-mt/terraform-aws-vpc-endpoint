# Changelog

## [1.0.0] - 2026-07-30

### Added
- Initial release: Interface and Gateway VPC endpoints from a single map
- Short service names expanded to the current region automatically
- Per-endpoint overrides for subnets, route tables, policy and tags
- Optional security group for Interface endpoints with HTTPS ingress from
  allowed security groups/CIDRs and egress scoped to the VPC CIDR
- Validations: endpoint type, Gateway restricted to s3/dynamodb,
  existing security group required when not creating one
