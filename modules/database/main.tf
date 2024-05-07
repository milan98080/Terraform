resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "aurora_postgres_credentials"
  description = "Credentials for Aurora PostgreSQL database"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "postgres"
    password = "SecurePassword123!" # Replace with a secure password
  })
}

resource "aws_db_subnet_group" "aurora_postgres_subnet_group" {
  name       = "aurora-postgres-subnet-group"
  subnet_ids = var.private_subnet_ids_for_cluster
}

resource "aws_security_group" "aurora_postgres_sg" {
  name        = "aurora-postgres-sg"
  description = "Security group for Aurora PostgreSQL Cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.backend_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "aurora_postgres_cluster" {
  cluster_identifier     = "aurora-postgres-cluster"
  engine                 = "aurora-postgresql"
  engine_version         = "13.4"
  database_name          = "mydb"
  master_username        = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string)["username"]
  master_password        = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string)["password"]
  db_subnet_group_name   = aws_db_subnet_group.aurora_postgres_subnet_group.name
  vpc_security_group_ids = [aws_security_group.aurora_postgres_sg.id]
  skip_final_snapshot    = true
}

resource "aws_rds_cluster_instance" "aurora_postgres_primary" {
  identifier           = "aurora-postgres-primary"
  cluster_identifier   = aws_rds_cluster.aurora_postgres_cluster.id
  instance_class       = "db.r5.large"
  engine               = "aurora-postgresql"
  engine_version       = "13.4"
  db_subnet_group_name = aws_db_subnet_group.primary_subnet_group.name
}

resource "aws_db_subnet_group" "primary_subnet_group" {
  name       = "primary-subnet-group"
  subnet_ids = [var.primary_db_subnet_id]
}

resource "aws_rds_cluster_instance" "aurora_postgres_replica" {
  identifier           = "aurora-postgres-replica"
  cluster_identifier   = aws_rds_cluster.aurora_postgres_cluster.id
  instance_class       = "db.r5.large"
  engine               = "aurora-postgresql"
  engine_version       = "13.4"
  db_subnet_group_name = aws_db_subnet_group.replica_subnet_group.name
}

resource "aws_db_subnet_group" "replica_subnet_group" {
  name       = "replica-subnet-group"
  subnet_ids = [var.primary_db_subnet_id]
}