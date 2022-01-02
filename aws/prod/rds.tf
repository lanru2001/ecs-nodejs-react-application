#Create a Database Using the RDS Instance in AWS

resource "aws_db_instance" "app_mysql" {
  
  count                           = var.create ? 1 : 0
  identifier                      = var.identifier
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  allocated_storage               = var.allocated_storage
  storage_type                    = var.storage_type
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = var.kms_key_id
  name                            = var.name
  username                        = var.username
  password                        = var.password
  port                            = var.db_instance_port
  vpc_security_group_ids          = [ aws_security_group.db_security_group.id ]
  db_subnet_group_name            = "${aws_db_subnet_group.db_subnet_group.name}"
  parameter_group_name            = aws_db_parameter_group.app_db_pg.name
  option_group_name               = var.option_group_name
  availability_zone               = "us-east-2a"  #var.azs
  multi_az                        = var.multi_az
  iops                            = var.iops
  publicly_accessible             = var.publicly_accessible
  allow_major_version_upgrade     = var.allow_major_version_upgrade
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  apply_immediately               = var.apply_immediately
  maintenance_window              = var.maintenance_window
  skip_final_snapshot             = var.skip_final_snapshot

  #performance_insights_enabled          = var.performance_insights_enabled
  #performance_insights_retention_period = var.performance_insights_retention_period 
  
  backup_retention_period = var.backup_retention_period
  max_allocated_storage   = var.max_allocated_storage
  #monitoring_interval     = var.monitoring_interval
  #monitoring_role_arn     = var.monitoring_interval > 0 ? local.monitoring_role_arn : null

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  deletion_protection             = var.deletion_protection
  delete_automated_backups        = var.delete_automated_backups

  tags = {
      "Name" = var.tag
  }

}

resource "aws_db_parameter_group" "app_db_pg" {
  name   = "${var.name_prefix }-pg"
  family = var.family

}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name}_subnet_group"
  subnet_ids = [ aws_subnet.app_public_subnets[0].id, aws_subnet.app_private_subnets[1].id ]

  tags = {
    Name = "My DB subnet group"
  }
}

# Security group 
resource "aws_security_group" "db_security_group" {
  name                      = "${local.module_prefix}-db-sg"
  description               = "Allow traffic for MySQL db"
  vpc_id                    =  aws_vpc.app_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    =  -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
