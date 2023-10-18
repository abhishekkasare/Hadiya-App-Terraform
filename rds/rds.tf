resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "tf-subgrp"
  subnet_ids = var.db_subnet_group
}

# RDS Database Instance
resource "aws_db_instance" "myinstance" {
  identifier           = var.db_instance_identifier
  storage_type         = var.rds_storage_type
  allocated_storage    = var.allocated_storage
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = var.rds_publicly_accessible
  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_class
  parameter_group_name = var.rds_parameter_group_name
  skip_final_snapshot  = var.rds_skip_final_snapshot
  option_group_name = var.rds_option_group_name
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}

# Security Group
resource "aws_security_group" "rds_sg" {
  vpc_id      = var.vpc_id
  name = var.security_group_name

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.security_group_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}