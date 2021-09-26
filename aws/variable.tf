terraform {
  required_version = ">= 0.12"
}

# ----------------------------------------------------------------------------------------------------------------------
# Module Standard Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  default     = ""
  description = "The AWS region to deploy module into"
}

variable "create" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization abbreviation, client name, etc. (e.g. Gravicore 'grv', HashiCorp 'hc')"
}

variable "environment" {
  type        = string
  default     = ""
  description = "The isolated environment the module is associated with (e.g. Shared Services `shared`, Application `app`)"
}

variable "stage" {
  type        = string
  default     = ""
  description = "The development stage (i.e. `dev`, `stg`, `prd`)"
}

variable "account_id" {
  type        = string
  default     = ""
  description = "The AWS Account ID that contains the calling entity"
}

#variable "tags" {
#  type        = map(string)
#  default     = ""
#  description = "Additional map of tags (e.g. business_unit, cost_center)"
#}

variable "desc_prefix" {
  type        = string
  default     = ""
  description = "The prefix to add to any descriptions attached to resources"
}

variable "s3_bucket_versioning" {
  type        = bool
  description = "S3 bucket versioning enabled"
  default     = true
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`"
}

variable "kms_master_key_arn" {
  type        = string
  default     = ""
  description = "The AWS KMS master key ARN used for the `SSE-KMS` encryption. This can only be used when you set the value of `sse_algorithm` as `aws:kms`. The default aws/s3 AWS KMS master key is used if this element is absent while the `sse_algorithm` is `aws:kms`"
}

variable "name" {
  type        = string
  default     = ""
  description = "The name of the module"
}

variable "vpc_cidr" {
  type = string
  default = ""
}

variable "vpc_id" {
  type = string
  default = ""
}

variable "ec2_count" {
  type = number 
  default = 1
}

variable "azs" {
  type = list(string)
  default = [ "" ]
}

variable "public_subnets_cidr" {
  type = list(string)
  default =  [ "" ]
}

variable "private_subnets_cidr" {
   type = list(string)
   default =  [ "" ]
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group name required to enabled logDriver in container definitions for ecs task."
  type        = string
  default     = ""
}

variable "cloudwatch_log_stream" {
  description = "CloudWatch log stream name"
  type        = string
  default     = ""
}

variable "docker_image" {
  description = "Docker image of the application"
  default     = ""
}

variable "fargate_cpu" {
  type        = number 
  description = "The cpu for the fargate container"
  default     = 64
}

variable "fargate_memory" {
  type        = number 
  description = "The memory for the fargate container"
  default     = 128

}

variable "node_container_port" {
  type        = string 
  description = "The node container port number "
  default     = ""

}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `environment`, `stage`, `name`"
}

variable "bucket_name" {
  description = "Number of ALB log bucket"
  default     = ""
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "The name of the ecs cluster"
}

variable "enabled" {
  type        = bool
  description = "Whether to create the resources. Set to `false` to prevent the module from creating any resources"
  default     = true
}

variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "task_container_command" {
  description = "The command that is passed to the container."
  default     = []
  type        = list(string)
}

variable "task_container_working_directory" {
  description = "The working directory to run commands inside the container."
  default     = ""
  type        = string
}

variable "placement_constraints" {
  type        = list
  description = "(Optional) A set of placement constraints rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. This is a list of maps, where each map should contain \"type\" and \"expression\""
  default     = []
}

variable "proxy_configuration" {
  type        = list
  description = "(Optional) The proxy configuration details for the App Mesh proxy. This is a list of maps, where each map should contain \"container_name\", \"properties\" and \"type\""
  default     = []
}

variable "volume" {
  description = "(Optional) A set of volume blocks that containers in your task may use. This is a list of maps, where each map should contain \"name\", \"host_path\", \"docker_volume_configuration\" and \"efs_volume_configuration\". Full set of options can be found at https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html"
  default     = []
}

variable "task_start_timeout" {
  type        = number
  description = "Time duration (in seconds) to wait before giving up on resolving dependencies for a container. If this parameter is not specified, the default value of 3 minutes is used (fargate)."
  default     = null
}

variable "task_stop_timeout" {
  type        = number
  description = "Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own. The max stop timeout value is 120 seconds and if the parameter is not specified, the default value of 30 seconds is used."
  default     = null
}

variable "task_mount_points" {
  description = "The mount points for data volumes in your container. Each object inside the list requires \"sourceVolume\", \"containerPath\" and \"readOnly\". For more information see https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html "
  type        = list(object({ sourceVolume = string, containerPath = string, readOnly = bool }))
  default     = null
}

variable "prevent_destroy" {
  type        = bool
  description = "S3 bucket lifecycle prevent destroy"
  default     = true
}

variable "bucket_prefix" {
  type        = string
  description = "S3 bucket prefix"
  default     = "db-treat"
}

variable "health_check_path" {
  type        = string
  description = "Path to check if the service is healthy , e.g \"/status\""
  default     = "/health"
}

variable "ami_id" {
  type        = string
  default     = ""
  description = "The Amazon machine image to use "
}

variable "PATH_TO_PRIVATE_KEY" {
  type    = string
  default = ""
}

variable "PATH_TO_PUBLIC_KEY" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "instance_tag" {
  type    = string
  default = ""
}

ariable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  type        = string
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  type        = string
  default     = null
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate."
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  type        = bool
  default     = false
}

variable "domain_iam_role_name" {
  description = "(Required if domain is provided) The name of the IAM role to be used when making API calls to the Directory Service"
  type        = string
  default     = null
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = ""
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = ""
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = ""
}

variable "name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = ""
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = ""
}

variable "password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = ""
}

variable "db_instance_port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = ""
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier_prefix" {
  description = "The name which is prefixed to the final snapshot on cluster destroy"
  type        = string
  default     = "final"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = string
  default     = ""
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
  default     = ""
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  type        = string
  default     = ""
}

variable "family" {
  description = "Family of the DB parameter group to"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  type        = string
  default     = ""
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  type        = number
  default     = 0
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  type        = number
  default     = 0
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring_interval is non-zero."
  type        = string
  default     = ""
}

variable "monitoring_role_name" {
  description = "Name of the IAM role which will be created when create_monitoring_role is enabled."
  type        = string
  default     = ""
}

variable "create_monitoring_role" {
  description = "Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
  type        = bool
  default     = false
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = null
}

variable "tag" {
  description = "Tag to assign to mysql db"
  type        = string
  default     = ""
}

variable "option_group_name" {
  description = "Name of the DB option group to associate."
  type        = string
  default     = ""
}

variable "timezone" {
  description = "(Optional) Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information."
  type        = string
  default     = null
}

variable "character_set_name" {
  description = "(Optional) The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS and Collations and Character Sets for Microsoft SQL Server for more information. This can only be set on creation."
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
  type        = list(string)
  default     = ["error", "general", "slowquery"]
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = false
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = true
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
  type        = number
  default     = 7
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 0
}

variable "ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  type        = string
  default     = null
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  type        = bool
  default     = true
}

locals {
 
  environment_prefix = join(var.delimiter, compact([var.namespace, var.environment]))
  stage_prefix       = join(var.delimiter, compact([local.environment_prefix, var.stage]))
  module_prefix      = join(var.delimiter, compact([local.stage_prefix, var.name]))
  #tags              = merge( var.namespace ,var.environment ,var.stage)
}
