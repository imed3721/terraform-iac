output "website_endpoint" {
  description = "The URL of the S3 static website hosted in the London AWS region."
  value       = "http://${var.website_bucket_name}.s3-website.eu-west-2.amazonaws.com"
}
