terraform {
  required_version = "~> 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.62"
    }
  }

  backend "s3" {
    bucket       = "demi-terra-state"
    key          = "terraform/devops-project.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}
