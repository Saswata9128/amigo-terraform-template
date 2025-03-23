resource "aws_rds_cluster" "aws_rds_cluster" {
  cluster_identifier              = var.rds_cluster_identifier
  engine                          = var.rds_engine
  engine_version                  = var.rds_engine_version
  engine_mode                     = var.rds_engine_mode
  enable_http_endpoint            = var.rds_http_endpoint
  #db_cluster_instance_class       = "db.t3.small"
  vpc_security_group_ids          = ["vpc-1737be6a"]
  db_subnet_group_name            = "default-vpc-1737be6a"
  availability_zones              = ["us-west-2a", "us-west-2b", "us-west-2c"]
  database_name                   = var.rds_cluster_identifier
  master_username                 = var.rds_username
  master_password                 = var.rds_password
  backup_retention_period         = 1
  preferred_backup_window         = "07:00-09:00"
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery", ]
}
