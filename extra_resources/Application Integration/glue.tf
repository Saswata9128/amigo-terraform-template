
resource "aws_glue_crawler" "crawler" {
  database_name = aws_athena_database.athena.name
  name          = var.project_name
  role          = "arn:aws:iam::892083583785:role/o365_kgs_read_s3_${var.account}"
  
  s3_target {
    # Change to match the bucket you want to crawl
    path = "s3://${aws_s3_bucket.s3_bucket[var.tables[0]].bucket}/"
  }
}
