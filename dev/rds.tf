resource "aws_rds_cluster" "data-platform-catalog-db" {
  cluster_identifier      = "data-platform-catalog-dev"
  database_name           = "data_platform_catalog_dev"
  engine                  = "aurora-postgresql"
  engine_mode             = "serverless"
  scaling_configuration {
    auto_pause               = true
    max_capacity             = 2
    min_capacity             = 2
    seconds_until_auto_pause = 14400
  }
  master_username         = "dataplatformadmin"
  master_password         = "Cars1234"
  backup_retention_period = "7"
  deletion_protection     = "true"
  final_snapshot_identifier = "data-platform-catalog-dev-final-snapshot"
  vpc_security_group_ids  = ["sg-09d2714c1aad2bb7c"]
  db_subnet_group_name    = "cars db subnet group"
  enable_http_endpoint    = true
  tags = {
    Name = "rds instance for data-platform-catalog"
    Env = "dev"
  }
}

terraform {
 required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    profile = "saml"
    region  = "us-east-1"
    bucket = "cars-terraform-data-np-state-files"
    key = "cars-terraform-data-platform/cars-data-platform-catalog-rds-dev/cars-data-platform-rds.tfstate"
  }
}

provider "aws" {
  region  = "us-east-1"
}
