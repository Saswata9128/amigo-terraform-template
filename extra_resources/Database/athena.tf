resource "aws_s3_bucket" "s3_bucket_athena" {
  for_each = toset(["db", "query"])
  bucket = "kgs-o365-athena-${each.key}"
}

resource "aws_athena_database" "athena" {
  name   = "${var.project_name}_athena_db"
  bucket = aws_s3_bucket.s3_bucket_athena["db"].bucket
}

resource "aws_athena_workgroup" "query_workgroup" {
  name = "${var.project_name}_athena_query"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.s3_bucket_athena["query"].bucket}/output/"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_athena" {
  for_each = aws_s3_bucket.s3_bucket_athena
  bucket = aws_s3_bucket.s3_bucket_athena[each.key].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# resource "aws_athena_named_query" "query" {
#   name      = "bar"
#   workgroup = aws_athena_workgroup.query_workgroup.id
#   database  = aws_athena_database.athena.name
#   query     = "SELECT * FROM ${aws_athena_database.athena.name} limit 10;"
# }
