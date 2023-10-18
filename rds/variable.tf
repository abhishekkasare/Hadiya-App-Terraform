
variable "region" {
  description = "The AWS region where the S3 bucket should be created."
}

variable "db_instance_identifier" {
  description = "RDS instance identifier"
}

variable "rds_storage_type" {
  description = "The storage type for the RDS instance."
}

variable "allocated_storage" {
  description = "Allocated storage for the RDS instance"
}

variable "db_username" {
  description = "Username for the RDS instance"
}

variable "db_password" {
  description = "Password for the RDS instance"
}

variable "rds_publicly_accessible" {
  description = "Whether the RDS instance is publicly accessible"
}

variable "security_group_name" {
  description = "Name of the security group"
}

variable "security_group_cidr" {
  description = "CIDR block for ingress rules"
}

variable "rds_engine" {
  description = "RDS engine"
  type        = string
}

variable "rds_engine_version" {
  description = "RDS engine version"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_parameter_group_name" {
  description = "RDS parameter group name"
  type        = string
}

variable "rds_skip_final_snapshot" {
  description = "Whether to skip the final snapshot"
  type        = bool
}

variable "rds_option_group_name" {
  description = "RDS Option group name"
  type = string
}

 variable "db_subnet_group" {
  description = "Subnet group for DB"
}

variable "vpc_id" {
  description = "Vpc Id for DB"
}