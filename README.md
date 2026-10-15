AWS Terraform DevOps Project
A small Infrastructure as Code project demonstrating Terraform, AWS S3, IAM and
GitHub Actions.
Architecture
GitHub → GitHub Actions → Terraform → AWS S3
Terraform state is stored remotely in an encrypted, versioned S3 bucket with S3-
native state locking.
Technologies
Terraform
AWS S3
AWS IAM
GitHub Actions
GitHub Secrets
CI/CD workflow
Pull requests run:
1. Terraform formatting
2. Terraform initialization
3. Terraform validation
Changes merged into main run:
1. Terraform initialization
2. Terraform plan
3. Terraform apply
AWS authentication
GitHub Actions authenticates to AWS using a dedicated IAM user and access keys
stored as GitHub repository secrets.
OIDC is intentionally not used in this implementation.
For a production deployment, short-lived credentials through GitHub OIDC would
generally be preferred.
Security AWS credentials are not stored in Git
GitHub Actions uses repository secrets
The IAM identity uses project-specific S3 permissions
Terraform state is stored remotely
Terraform state bucket versioning is enabled
Terraform state locking is enabled
Public access is limited to the website bucket's GetObject operation
Website
The project hosts a simple static HTML website using Amazon S3.
The S3 website endpoint is HTTP-only. A production implementation should use
CloudFront and Origin Access Control to provide HTTPS and keep the S3 bucket
private.
Cleanup
The repository includes a manually triggered GitHub Actions workflow that runs:
terraform destroy
The Terraform state bucket is intentionally created manually and should be deleted
manually after the Terraform-managed infrastructure has been destroyed.
