# Complete example

Creates the endpoint set typically needed by EKS nodes running in private
subnets with no NAT gateway:

- Gateway: S3, DynamoDB (free, route-table based)
- Interface: ECR API/DKR, CloudWatch Logs, STS, Secrets Manager

Access is restricted to the EKS node security group over HTTPS.

## Usage

```bash
terraform init
terraform apply \
  -var "vpc_id=vpc-xxxx" \
  -var "vpc_cidr=10.20.0.0/16" \
  -var 'private_subnet_ids=["subnet-a","subnet-b","subnet-c"]' \
  -var 'route_table_ids=["rtb-a"]' \
  -var "eks_node_security_group_id=sg-cccc"
```
