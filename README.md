# AWS Terraform Infrastructure as Code

A hands-on DevOps portfolio project demonstrating how to provision AWS infrastructure with Terraform, automate infrastructure validation and deployment using GitHub Actions, and manage Terraform state remotely in Amazon S3.

The project hosts a static HTML website on Amazon S3 and uses a Git-based workflow to manage infrastructure changes. It also explores pull requests, CI/CD deployment testing, and infrastructure drift detection.

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
    +---- Push / Merge to main
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

## Technologies

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| Amazon S3 | Static website hosting and remote state storage |
| AWS IAM | Identity and access management |
| GitHub Actions | Automated validation and deployment |
| GitHub Secrets | Storing deployment credentials and configuration |
| Git and GitHub | Version control, branching and pull requests |
| YAML | CI/CD workflow configuration |
| JSON | AWS policy configuration |

## Key Features

### 1. Infrastructure as Code

AWS resources are defined and managed using Terraform configuration files.

This allows infrastructure changes to be version-controlled, reviewed, planned and applied through a repeatable workflow rather than relying entirely on manual AWS Console operations.

### 2. Amazon S3 Static Website Hosting

The project hosts a simple HTML website using Amazon S3 static website hosting.

The website configuration includes:

- An `index.html` document.
- An error document configuration.
- A bucket policy allowing public read access to website objects.
- Public access block settings configured for the intended public website.
- Server-side encryption for the uploaded HTML object.

The website bucket is separate from the Terraform state bucket.

**Production consideration:** The S3 static website endpoint uses HTTP. A production implementation could use CloudFront with Origin Access Control and a private S3 origin to provide HTTPS delivery.

### 3. Remote Terraform State Management

Terraform state is stored in a dedicated S3 bucket rather than relying on a local state file.

The backend configuration uses:

- Remote state storage in Amazon S3.
- S3 bucket versioning to support recovery of earlier state versions.
- S3-native state locking using `use_lockfile`.
- Server-side encryption for state data.

The state bucket is managed separately from the website infrastructure. This helps preserve the Terraform state when the website resources are destroyed.

### 4. CI/CD with GitHub Actions

GitHub Actions automates infrastructure validation and deployment.

**Pull request workflow**

When a pull request targets `main`, the validation workflow runs:

1. Terraform formatting checks.
2. Terraform initialization with the remote backend disabled.
3. Terraform validation.

This helps identify formatting and configuration problems before changes are merged.

**Deployment workflow**

When code is pushed or merged into `main`, the deployment workflow runs:

1. Terraform initialization.
2. Terraform formatting checks.
3. Terraform plan.
4. Terraform apply.

Terraform generates a plan before applying the proposed changes.

The workflow also uses GitHub Actions concurrency controls to prevent overlapping deployment runs.

### 5. AWS Authentication and IAM

GitHub Actions authenticates to AWS using an IAM identity and credentials stored in GitHub repository secrets.

The repository does not hard-code AWS access keys in its source files.

This implementation uses IAM access keys rather than GitHub OIDC federation. For production deployments, OIDC with short-lived AWS credentials would generally be preferable to long-lived access keys.

IAM permissions should be restricted to the resources and operations required by the project.

## Testing and Validation

This project includes practical tests to explore how code changes move through GitHub and how Terraform manages AWS infrastructure.

### Test 1: Pull Request Workflow

I created a feature branch, made changes, opened a pull request and merged the changes into `main`.

This allowed me to practise a branch-based development workflow and use GitHub Actions to validate changes before merging.

**Skills demonstrated:**

- Feature branches and version control.
- Pull request creation and merging.
- Automated Terraform validation.
- Managing infrastructure changes through Git.

<details>
<summary><strong>Pull request and validation screenshots</strong></summary>

**Pull request and code review workflow**

![Pull request workflow screenshot 1](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.48.17.png)

![Pull request workflow screenshot 2](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.48.56.png)

**Workflow execution and validation evidence**

![Validation screenshot 3](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.49.44.png)

![Validation screenshot 4](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.50.22.png)

![Validation screenshot 5](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.50.27.png)

![Validation screenshot 6](https://github.com/imed3721/terraform-iac/blob/2d9f1c3221cd5c2e6949b66428c52d92a78597b5/screenshots/Screenshot%202026-10-15%20at%2013.50.34.png)

</details>

### Test 2: CI/CD Website Deployment

I tested the deployment workflow by changing the website header text in `index.html`.

After merging the change into `main`, I checked the GitHub Actions workflow to test the automated Terraform deployment process and the update to the website hosted on Amazon S3.

This test demonstrates how a small application change can move through version control and trigger an automated deployment workflow.

**Skills demonstrated:**

- Changing and committing application code.
- Using pull requests to manage changes.
- Running GitHub Actions workflows.
- Using Terraform plan and apply.
- Updating a static website through a CI/CD workflow.

<details>
<summary><strong>Website deployment test screenshots</strong></summary>

![Website deployment screenshot 1](https://github.com/imed3721/terraform-iac/blob/92caf70cf5b76f26b4d14c3d6d14adae2e20051a/screenshots/Screenshot%202026-10-15%20at%2013.58.23.png)

![Website deployment screenshot 2](https://github.com/imed3721/terraform-iac/blob/92caf70cf5b76f26b4d14c3d6d14adae2e20051a/screenshots/Screenshot%202026-10-15%20at%2013.58.30.png)

![Website deployment screenshot 3](https://github.com/imed3721/terraform-iac/blob/92caf70cf5b76f26b4d14c3d6d14adae2e20051a/screenshots/Screenshot%202026-10-15%20at%2013.58.38.png)

![Website deployment screenshot 4](https://github.com/imed3721/terraform-iac/blob/92caf70cf5b76f26b4d14c3d6d14adae2e20051a/screenshots/Screenshot%202026-10-15%20at%2013.58.42.png)

</details>

### Test 3: Terraform Infrastructure Drift

I explored infrastructure drift by manually changing the S3 static website's error document configuration in the AWS Console, outside Terraform.

The purpose of this test is to compare the live AWS configuration with the desired configuration defined in Terraform.

A Terraform plan can identify proposed changes needed to bring managed resources back into alignment with the configuration.

**Skills demonstrated:**

- Understanding infrastructure drift.
- Identifying changes made outside Infrastructure as Code.
- Using Terraform plans to inspect infrastructure differences.
- Understanding the importance of configuration consistency.

**Test result:** The drift test is confirmed successful when the Terraform plan displays the manually introduced S3 configuration change. A manual change alone does not prove that Terraform successfully detected it.

<details>
<summary><strong>Infrastructure drift test screenshots</strong></summary>

![Drift test screenshot 1](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.02.34.png)

![Drift test screenshot 2](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.02.40.png)

![Drift test screenshot 3](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.02.45.png)

![Drift test screenshot 4](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.02.51.png)

![Drift test screenshot 5](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.02.56.png)

![Drift test screenshot 6](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.03.02.png)

![Drift test screenshot 7](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.03.07.png)

![Drift test screenshot 8](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.03.11.png)

![Drift test screenshot 9](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.03.25.png)

![Drift test screenshot 10](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.03.29.png)

![Drift test screenshot 11](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.03.33.png)

![Drift test screenshot 12](https://github.com/imed3721/terraform-iac/blob/19c3e86c608c2decb6e4dfdee3f86063dfc4588e/screenshots/Screenshot%202026-10-15%20at%2014.03.36.png)

</details>

## AWS Configuration

The project uses the AWS London region (`eu-west-2`).

The GitHub repository uses these secrets:

| Secret | Purpose |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS access key for the deployment identity |
| `AWS_SECRET_ACCESS_KEY` | Secret access key for the deployment identity |
| `WEBSITE_BUCKET_NAME` | Name of the S3 website bucket |

The Terraform backend uses a separately managed S3 state bucket and a dedicated state file key.

Before deployment, the state bucket must exist, the AWS identity must have the required permissions, and the repository secrets must match the intended AWS resources.

## Security Considerations

Security measures and design decisions include:

- AWS credentials stored in GitHub repository secrets.
- IAM-based access control.
- Remote Terraform state storage.
- S3 state bucket versioning.
- S3-native state locking.
- Server-side encryption for the uploaded website object.
- Public read access for website objects through the S3 bucket policy.

### Known Limitations and Future Improvements

- Replace long-lived IAM access keys with GitHub OIDC federation.
- Review and tighten IAM permissions using least privilege.
- Add approval controls for production deployments and infrastructure destruction.
- Implement a dedicated plan-only drift detection workflow.
- Use CloudFront with Origin Access Control for HTTPS delivery with a private S3 origin.
- Improve deployment reporting and failure notifications.

## Infrastructure Cleanup

The repository includes a manually triggered GitHub Actions workflow that runs:

```bash
terraform destroy
```

This provides a repeatable way to remove Terraform-managed infrastructure when it is no longer required.

The destroy workflow must only be run after reviewing the resources that will be removed. Resources may be permanently deleted, including website contents if the bucket is configured with `force_destroy = true`.

The Terraform state bucket is managed separately and should be retained while the state is still required. If it is no longer needed, it must be deleted separately after carefully considering state recovery and retention requirements.

## Key Learnings

Through this project, I gained practical experience with:

- Defining AWS infrastructure using Terraform.
- Managing remote state, state versioning and locking.
- Configuring IAM permissions for automated infrastructure management.
- Building GitHub Actions CI/CD workflows.
- Using pull requests to validate and manage changes.
- Automating Terraform plan and apply operations.
- Hosting a static website on Amazon S3.
- Managing S3 website configuration and bucket policies.
- Exploring infrastructure drift and Terraform plan output.
- Separating application infrastructure from Terraform state management.
- Identifying security improvements and planning infrastructure cleanup.

## Future Improvements

Planned improvements include:

- Migrating AWS authentication to GitHub OIDC.
- Implementing and validating automated drift detection.
- Requiring approval before production deployments and infrastructure destruction.
- Introducing automated security and policy checks.
- Using CloudFront and Origin Access Control for HTTPS website delivery.
- Improving deployment reporting and failure notifications.

## Project Objective

This project demonstrates a practical approach to AWS infrastructure automation using Terraform and GitHub Actions. It brings together Infrastructure as Code, version control, CI/CD, remote state management, IAM security and hands-on testing in a single DevOps portfolio project.
