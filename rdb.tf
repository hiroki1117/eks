resource "aws_db_parameter_group" "default" {
  name   = var.db_parameter_group_name
  family = "postgres9.6"
}

resource "aws_db_instance" "default" {
  identifier                = var.db_id
  allocated_storage         = 10
  storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = "9.6.15"
  instance_class            = var.db_instance_class
  name                      = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.rds-subnet-group.name
  parameter_group_name      = var.db_parameter_group_name
  multi_az                  = var.db_multi_az
  backup_retention_period   = var.db_backup_retention_period
  backup_window             = "02:10-02:40"
  vpc_security_group_ids    = [aws_security_group.db-sg.id]
  skip_final_snapshot       = var.db_skip_final_snapshot
  final_snapshot_identifier = "${var.db_id}-final-snapshot"
  apply_immediately         = true

  tags = {
    Name = "${var.db_id}-postgres"
  }
}