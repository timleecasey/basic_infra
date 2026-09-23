terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

# Alphanumeric only: RDS rejects / @ " and space in master passwords, and the
# password is embedded in the dsn output.
resource "random_password" "master" {
  length  = 32
  special = false
}

resource "aws_db_subnet_group" "this" {
  name       = local.name
  subnet_ids = var.subnet_ids
  tags       = local.tags
}

resource "aws_db_instance" "this" {
  identifier                = local.name
  engine                    = "postgres"
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  allocated_storage         = var.allocated_storage
  storage_type              = "gp3"
  storage_encrypted         = true
  db_name                   = var.db_name
  username                  = var.username
  password                  = random_password.master.result
  db_subnet_group_name      = aws_db_subnet_group.this.name
  vpc_security_group_ids    = var.security_group_ids
  publicly_accessible       = false
  backup_retention_period   = var.backup_retention_period
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = false
  final_snapshot_identifier = "${local.name}-final"
  tags                      = local.tags
}
