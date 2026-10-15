# AWS Terraform Infrastructure as Code Project

A hands-on DevOps project demonstrating how to provision and manage AWS infrastructure using Terraform, automate infrastructure validation and deployment with GitHub Actions, and manage Terraform state remotely in Amazon S3.

The project hosts a static HTML portfolio website on Amazon S3, with infrastructure managed through version-controlled Terraform configuration.

## Architecture

```text
Developer
   |
   v
GitHub Repository
   |
   +---- Pull Request
   |         |
   |         v
   |    GitHub Actions
   |    - Terraform Format
   |    - Terraform Init
   |    - Terraform Validate
   |
   +---- Merge / Push to main
             |
             v
        GitHub Actions
        - Terraform Init
        - Terraform Plan
        - Terraform Apply
             |
             v
         AWS Resources
         - S3 Website Bucket
         - Website Configuration
         - Bucket Policy
             |
             v
      Static HTML Website

Terraform State
      |
      v
Dedicated S3 State Bucket
- Remote State Storage
- Versioning
- S3-Native State Locking
```

## Technologies Used

- **Terraform** — Infrastructure as Code (IaC)
- **Amazon S3** — Static website hosting and remote Terraform state storage
- **AWS IAM** — Access control and permissions
- **GitHub Actions** — Automated infrastructure validation and deployment
- **GitHub Secrets** — Storage of AWS credentials and project configuration
- **Git and GitHub** — Version control, branches, and pull requests
- **YAML** — GitHub Actions workflow configuration
- **JSON** — AWS IAM and S3 bucket policy configuration

## Key Features

### 1. Infrastructure as Code

AWS resources are defined and managed using Terraform configuration files rather than being created entirely through manual console operations.

This makes the infrastructure easier to review, maintain, reproduce, and update through version control.

### 2. Static Website Hosting

The project deploys a simple HTML website to Amazon S3.

The website configuration includes:

- An index document (`index.html`)
- An error document configuration
- A bucket policy allowing public read access to website objects
- Public access block settings configured to support the website's intended access model
- Server-side encryption for the uploaded HTML object

The website bucket is separate from the bucket used to store Terraform state.

### 3. Remote Terraform State

Terraform state is stored in a dedicated Amazon S3 bucket rather than relying on a local state file.

The remote state configuration uses:

- S3 remote state storage
- Bucket versioning to help recover previous state versions
- S3-native state locking using `use_lockfile`
- Server-side encryption for state data

The state bucket is managed separately from the website infrastructure so that Terraform state can remain available when the website resources are destroyed.

### 4. CI/CD with GitHub Actions

GitHub Actions automates infrastructure validation and deployment.

**Pull request workflow**

When a pull request targets `main`, the workflow runs:

1. Terraform formatting checks
2. Terraform initialization without connecting to the remote backend
3. Terraform validation

This helps identify formatting and configuration issues before changes are merged.

**Deployment workflow**

When code is pushed or merged into `main`, the deployment workflow runs:

1. Terraform initialization
2. Terraform formatting checks
3. Terraform plan
4. Terraform apply

Terraform generates a plan before applying the proposed infrastructure changes.

The deployment workflow also uses GitHub Actions concurrency controls to prevent overlapping deployment runs.

### 5. AWS Authentication and IAM

GitHub Actions authenticates to AWS using a dedicated IAM identity and credentials stored as GitHub repository secrets.

AWS credentials are not hard-coded into the repository.

This implementation uses IAM access keys rather than GitHub OIDC federation. For production deployments, GitHub OIDC with short-lived AWS credentials would generally be preferable to long-lived access keys.

IAM permissions should be restricted to the resources and operations required by the project.

## Testing and Validation

### 1. Pull Request Workflow

Created a feature branch, made changes, and opened a pull request to merge the changes into `main`.

This allowed me to practise a version-controlled development workflow and understand how changes can be reviewed before being merged into the main branch.

**What I practised:**
- Feature branches
- Pull requests and merging changes
- Automated validation before deployment
- Version-controlled infrastructure changes

![Image Alt](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.48.17.png)

![Image Alt](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.48.56.png)

![Image Alt](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.49.44.png)

![Image Alt](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.50.22.png)

![Image Alt](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.50.27.png)

![Image Alt](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.50.34.png)


### 2. CI/CD Deployment Test

Tested the GitHub Actions deployment workflow by changing the website's header text in `index.html`.

After merging the change into `main`, I used GitHub Actions to test the automated Terraform deployment process and the updating of the website hosted on Amazon S3.

**What this demonstrates:**
- Git-based change management
- Pull request and merge workflows
- GitHub Actions execution
- Terraform plan and apply
- Automated website updates through a CI/CD workflow

### 3. Terraform Drift Testing

Tested infrastructure drift by manually changing the S3 static website's error document configuration in the AWS Console, independently of Terraform.

The intended validation is to run a Terraform plan through GitHub Actions and check whether Terraform identifies the difference between the live AWS configuration and the desired Terraform configuration.

**What this demonstrates:**
- Understanding infrastructure drift
- Identifying changes made outside Infrastructure as Code
- Using Terraform plans to inspect proposed infrastructure changes
- The importance of maintaining consistency between AWS resources and Terraform configuration

The drift test should be considered successful once the Terraform plan has confirmed and displayed the manually introduced change.

## AWS Authentication and Configuration

The project is configured for the AWS London region (`eu-west-2`).

GitHub Actions uses the following repository secrets:

| Secret | Purpose |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS access key for the deployment identity |
| `AWS_SECRET_ACCESS_KEY` | Secret access key for the deployment identity |
| `WEBSITE_BUCKET_NAME` | Name of the S3 website bucket |

The Terraform backend uses a separately managed S3 state bucket and a dedicated state file key.

Before deployment, the state bucket must exist, the AWS identity must have the required permissions, and the repository secrets must match the intended AWS resources.

## Security Considerations

Security measures implemented in this project include:

- AWS credentials stored in GitHub repository secrets
- IAM-based access control
- Remote Terraform state storage
- S3 state bucket versioning
- S3-native state locking
- Server-side encryption for the uploaded website object
- Public read access for website objects through the S3 bucket policy

### Known Limitations and Future Improvements

- Replace long-lived IAM access keys with GitHub OIDC federation.
- Review and tighten IAM permissions using least privilege.
- Add approval controls for production deployments and infrastructure destruction.
- Add a dedicated plan-only drift detection workflow.
- Consider CloudFront with Origin Access Control for HTTPS delivery while keeping the S3 origin private.
- Improve deployment reporting and failure notifications.

## Infrastructure Cleanup

The repository includes a manually triggered GitHub Actions workflow for running:

```bash
terraform destroy
```

This provides a repeatable way to remove Terraform-managed infrastructure when it is no longer required.

The destroy workflow should only be run after reviewing the resources that will be removed. Resources managed by Terraform may be permanently deleted, including website contents if the bucket is configured with `force_destroy = true`.

The Terraform state bucket is intentionally managed separately and should be retained until the state is no longer required. If it is eventually deleted, this must be done separately.

## What I Learned

Through this project, I practised:

- Defining AWS infrastructure using Terraform
- Managing Terraform state remotely
- Understanding state versioning and state locking
- Configuring IAM permissions for automated infrastructure management
- Building CI/CD workflows with GitHub Actions
- Using pull requests to validate infrastructure changes
- Automating Terraform plan and apply operations
- Hosting a static website on Amazon S3
- Managing S3 bucket policies and website configuration
- Understanding infrastructure drift and how Terraform plans can identify differences
- Separating website infrastructure from Terraform state management
- Planning infrastructure cleanup and identifying security improvements

## Future Improvements

Potential next steps include:

- Migrating AWS authentication to GitHub OIDC
- Implementing and validating a dedicated drift detection workflow
- Requiring approval before production deployments and infrastructure destruction
- Introducing automated security and policy checks
- Using CloudFront and Origin Access Control for HTTPS website delivery
- Improving deployment reporting and failure notifications

## Project Goal

This project demonstrates a practical introduction to AWS infrastructure automation and DevOps workflows, combining Infrastructure as Code, version control, CI/CD, remote state management, and IAM security in one portfolio project.
