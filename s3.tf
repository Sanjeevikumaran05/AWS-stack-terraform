resource "aws_s3_bucket" "web_assets" {
  bucket = "my-web-assets"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "web_assets_policy" {
  bucket = aws_s3_bucket.web_assets.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowEC2Access",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:*",
        Resource  = "${aws_s3_bucket.web_assets.arn}/*",
        Condition = {
          IpAddress : {
            "aws:SourceIp" : "${aws_instance.web.private_ip}"
          }
        }
      }
    ]
  })
}

