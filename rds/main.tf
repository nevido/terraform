provider "aws" {
  region = local.region
}
data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../vpc/terraform.tfstate"
  }
}


locals {
  create_db_instance        = var.create_db_instance 
  
  name = "test-mysql"
  region = "ap-northeast-2"
  engine = "mysql"
  engine_version = "8.0.27"
  family = "mysql8.0"           # DB Parameter group
  major_engine_version = "8.0"  # DB option group
  #instance_class = "db.m1.small"   #db.t4g.large
  instance_class = "db.t4g.large"   #db.t4g.large
  allocated_storage = 20
  max_allocated_storage = 40
  db_name = "nevido"
  user_name = "nevido"
  port = 3306
  multi_az = true
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]
  create_cloudwatch_log_group = true
  
  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection = false
  
  
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  create_monitoring_role        = true
  monitoring_interval           = 60
  
  owner = "jaeyonglee"
  team = "infra-1"
  
  
  
 ######### Don't touch #######################################
  create_random_password = local.create_db_instance && var.create_random_password
  password               = local.create_random_password ? random_password.master_password[0].result : var.password
  public_sub =  data.terraform_remote_state.vpc.outputs.public_subnets
  private_sub = data.terraform_remote_state.vpc.outputs.private_subnets
  database_sub = data.terraform_remote_state.vpc.outputs.database_subnets
  security_group_default = data.terraform_remote_state.vpc.outputs.default_security_group_id
  azs = data.terraform_remote_state.vpc.outputs.azs
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_blocks = data.terraform_remote_state.vpc.outputs.database_subnets_cidr_blocks
  create_db_subnet_group    = var.create_db_subnet_group
  db_subnet_group_name    = var.create_db_subnet_group ? module.db_subnet_group.db_subnet_group_id : var.db_subnet_group_name
  
}

resource "random_password" "master_password" {
  count = local.create_random_password ? 1 : 0

  length  = var.random_password_length
  special = false
}


module "db_subnet_group" {
  source = "../modules/db_subnet_group"

  create = local.create_db_subnet_group

  name            = "${local.name}-db-subnet-group"
 # use_name_prefix = var.db_subnet_group_use_name_prefix
  #description     = var.db_subnet_group_description
  subnet_ids      = local.database_sub

  #tags = merge(local.owner,local.team)
#   tags = merge(var.tags, var.db_subnet_group_tags)
  tags = {
   Terraform = local.owner
   Environment = local.team
   
 }
 
 }




module "db_instance" {
  source ="../modules/db_instance"
  identifier = local.name
  engine = local.engine
  engine_version = local. engine_version
  family = local.family
  major_engine_version = local.major_engine_version
  instance_class = local.instance_class
  
  allocated_storage = local.allocated_storage
  max_allocated_storage = local.max_allocated_storage
  
  db_name = local.db_name
  username = local.user_name
  password = local.password
  port = local.port
  multi_az = local.multi_az
  subnet_ids = local.database_sub
  cidr_blocks = local.cidr_blocks

  db_subnet_group_name   = local.db_subnet_group_name
  
  maintenance_window = local.maintenance_window
  backup_window = local.backup_window
  enabled_cloudwatch_logs_exports = local.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group = local.create_cloudwatch_log_group
  backup_retention_period = local.backup_retention_period
  skip_final_snapshot = local.skip_final_snapshot
  deletion_protection = local.deletion_protection
  performance_insights_enabled = local.performance_insights_enabled
  performance_insights_retention_period = local.performance_insights_retention_period
  create_monitoring_role        = local.create_monitoring_role
  monitoring_interval           = local.monitoring_interval
  vpc_id = local.vpc_id
  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]


  tags = {
   Terraform = local.owner
   Environment = local.team
 }
 
 
  db_instance_tags = {
    "Sensitive" = "high"
  }
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
  
  ingress_with_cidr_blocks = [
    {
      type        = "ingress"
      from_port   = local.port
      to_port     = local.port
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = local.cidr_blocks
   },
   
  ]

  
}