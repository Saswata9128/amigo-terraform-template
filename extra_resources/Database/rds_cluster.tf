# rds cluster Resource
resource "aws_rds_cluster" "rds_cluster_name" {
  cluster_identifier = var.rds_cluster_name
  engine = var.engine
  engine_version = var.engine_version
  engine_mode = var.engine_mode
  enable_http_endpoint = var.enable_http_endpoint
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name = aws_db_subnet_group.cloudvoice.name
  availability_zones = var.availability_zones
  database_name = var.database_name
  master_username = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]
  master_password = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]
  backup_retention_period = var.backup_retention_period
  preferred_backup_window =var.preferred_backup_window
  deletion_protection = true
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = var.rds_secret
}

resource "aws_db_subnet_group" "cloudvoice" {
  name       = var.database_name
  subnet_ids = var.subnet_ids

}

data "local_file" "sql_script" {
  filename = "${path.module}/table_build.sql"
}
