variable "aws_region" {
  description = "AWS region where the website will be deployed."
  type        = string
  default     = "eu-west-2"
}

variable "website_bucket_name" {
  description = "Globally unique S3 bucket name for the website."
  type        = string
  default     = "demi-terra-site"
}
