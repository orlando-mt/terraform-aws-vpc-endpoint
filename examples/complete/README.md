# Complete example

Creates the endpoint set typically needed by EKS nodes running in private
subnets with no NAT gateway:

- Gateway: S3, DynamoDB (free, route-table based)
- Interface: ECR API/DKR, CloudWatch Logs, STS, Secrets Manager

Access is restricted to the EKS node security group over HTTPS.

Replace the placeholder IDs in [`terraform.tfvars`](./terraform.tfvars) with
resources from your account before applying.

## Usage

```bash
terraform init
terraform plan
terraform apply
```
