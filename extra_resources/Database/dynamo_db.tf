#DynamoDB Resource
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = var.dynamo_db_name
  billing_mode   = var.billing_mode
  hash_key       = "name"

  dynamic "attribute" {
    for_each = var.dynamo_db_attributes
    content{
      name = attribute.key
      type = attribute.value
    }
  }
}
