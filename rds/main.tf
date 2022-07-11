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
  name = "test-mysql"
  region = "ap-northeast-2"
  engine = "mysql"
  engine_version = "8.0.27"
  family = "mysql8.0"           # DB Parameter group
  major_engine_version = "8.0"  # DB option group
  instance_class = "db.t4g.large"
  
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
  
 ######### Don't touch #######################################
  public_sub =  data.terraform_remote_state.vpc.outputs.public_subnets
  private_sub = data.terraform_remote_state.vpc.outputs.private_subnets
  database_sub = data.terraform_remote_state.vpc.outputs.database_subnets
  security_group_default = data.terraform_remote_state.vpc.outputs.default_security_group_id
  azs = data.terraform_remote_state.vpc.outputs.azs
  
  
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
  username = local.username
  port = local.port
  multi_az = local.multi_az
  subnet_ids = local.database_sub
  vpc_security_group_ids = local.security_group_default
  
}