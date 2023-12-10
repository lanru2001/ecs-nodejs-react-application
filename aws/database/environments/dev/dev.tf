
# S3 remote state 

terraform {
 backend "s3" {
    bucket         = "tf-state-file01"  
    key            = "project/dev/rds"
    region         = "us-east-2"
    dynamodb_table = "eks_ecommerce_dynamodb"

 }
}

module "dev_db"  {
  
  source                          = "../../"
  engine_version                  = "12.8"
  engine                          = "postgres"
  instance_class                  = "db.t3.small"
  allocated_storage               =  "20"
  storage_type                    = "gp2"
  storage_encrypted               = false
  family                          = "postgres12"
  #kms_key_id                     = 
  identifier                      = "uat-rds-seed"
  db_name                         = "uatRdsSeed"
  #username                        = "postgresql"
  #password                        = "Openssh1!"
  vpc_security_group_ids          =  [ "sg-0e21285b96d9869d1" ]
  subnet_ids                      = [ "subnet-072e54b62a6d1944d", "subnet-0e07ca691f789db64", "subnet-0288aaf61f04bddac","subnet-03dc15dc94e5967aa"  ]
  db_instance_port                = "5432"
  #option_group_name               = 
  multi_az                        = "true"
  iops                            = 0
  allow_major_version_upgrade     = false
  auto_minor_version_upgrade      = true
  apply_immediately               = false
  skip_final_snapshot             = true

  performance_insights_enabled    = true
  performance_insights_retention_period = 7
  
  backup_retention_period         = "7"
  #max_allocated_storage           = "20"
  #monitoring_interval            = var.monitoring_interval
  #monitoring_role_arn            = var.monitoring_interval > 0 ? local.monitoring_role_arn : null

  enabled_cloudwatch_logs_exports =  [ "postgresql", "upgrade" ]
  deletion_protection             = false
  delete_automated_backups        = true
  db_subnet_group_name            = "uat_db_subnet_group"
  parameter_group_name            = "uat-db-pg"
  maintenance_window              = "Mon:00:00-Mon:03:00"
  secretmanager_name              = "uat/postgres/uat-rds-seed"

}
