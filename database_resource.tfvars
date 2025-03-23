//region DynamoDB
  billing_mode = "PAY_PER_REQUEST"

  dynamo_db_name = "Dev_hello_world_tf"

  dynamo_db_attributes = {key: "type"}
//endregion


//region RDS DB
  rds_cluster_identifier = "cloudvoiceintendtedstates"
  rds_engine = "aurora-mysql"
  rds_engine_version = "8.0.mysql_aurora.3.02.0"
  rds_engine_mode = "serverless"
  rds_secret = "arn:aws:secretsmanager:us-east-1:123456789:secret:rdssecret"
  rds_http_endpoint = true
//endregion
