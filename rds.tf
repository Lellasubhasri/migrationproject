resource "aws_db_subnet_group" "dbsg" {
    name = "main"
    subnet_ids = [module.vpc.database_subnets[0], module.vpc.database_subnets[1]]
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "rdspgres" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "postgres"
  engine_version       = "14.6"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.postgres14"
  maintenance_window   = "Mon:00:00-Mon:03:00"
  backup_window        = "10:00-12:00"
  auto_minor_version_upgrade = true
  skip_final_snapshot  = true
  backup_retention_period = 7
  copy_tags_to_snapshot = true
  #enable_point_in_time_recovery = true
 
 dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time
    content {
    restore_time = restore_to_point_in_time.value["restore_time"]
    source_db_instance_identifier = restore_to_point_in_time.value["source_db_instance_identifier"]
    source_dbi_resource_id = restore_to_point_in_time.value["source_dbi_resource_id"]
    use_latest_restorable_time = restore_to_point_in_time.value["use_latest_restorable_time"]
    }
  }
  #subnet_id = module.vpc.database_subnets[0]
  db_subnet_group_name = aws_db_subnet_group.dbsg.id
}



resource "aws_security_group" "rdssg" {
  vpc_id      = module.vpc.vpc_id
  name        = "rdssg"
  description = "Allow all inbound for Postgres"
ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
