# Create the S3 bucket for website hosting
resource "aws_s3_bucket" "website" {
  bucket        = var.website_bucket_name
  force_destroy = true
}

# Configure public access settings for the website bucket
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Allow public read access to website files
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"

        Action = [
          "s3:GetObject"
        ]

        Resource = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.website
  ]
}

# Upload the website homepage
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html"

  source       = "${path.module}/website/index.html"
  content_type = "text/html"

  etag                   = filemd5("${path.module}/website/index.html")
  server_side_encryption = "AES256"
}
