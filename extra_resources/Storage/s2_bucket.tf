# S3 Bucket Resource
resource "aws_s3_bucket" "s3_bucket" {
  bucket = lower("${var.project}_${var.env}")
}


resource "aws_s3_bucket_ownership_controls" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
     object_ownership = "BucketOwnerPreferred"
  }
}
