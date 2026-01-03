provider "aws" {
  region = var.region
}

# DB Subnet Group（EC2と同じ Subnet を使う）
resource "aws_db_subnet_group" "this" {
  name       = "aurora-mysql-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "aurora-mysql-subnet-group"
  }
}

# Aurora Cluster
resource "aws_rds_cluster" "this" {
  cluster_identifier = "aurora-mysql-simple"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.05.2"

  master_username = "admin"
  master_password = "Password123!" # ← 検証用。本番は Secrets Manager 推奨

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids

  skip_final_snapshot = true

  tags = {
    Name = "aurora-mysql-simple"
  }
}

# Writer Instance（1台だけ）
resource "aws_rds_cluster_instance" "writer" {
  identifier         = "aurora-mysql-simple-writer"
  cluster_identifier = aws_rds_cluster.this.id

  instance_class = "db.t3.medium"
  engine         = aws_rds_cluster.this.engine
  engine_version = aws_rds_cluster.this.engine_version

  publicly_accessible = false

  tags = {
    Name = "aurora-mysql-simple-writer"
  }
}
