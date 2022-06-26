provider "aws" {
  region = local.region
}

###########################################
# User Insert Information what you want to 
##########################################
locals {

 
  region = "ap-northeast-2"
  project_name = "nevido"
  vpc_name = "simple-vpc"
  cidr = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_use = true
  database_subnets  = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
  enable_ipv6 = true
  create_vpc = true
  enable_nat_gateway = true
  single_nat_gateway = true
  
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../modules/vpc"

  name = local.vpc_name
  cidr = local.cidr

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  database_subnets  = local.database_subnets
  database_use = local.database_use
  enable_ipv6 = local.enable_ipv6
  
  create_vpc = local.create_vpc
  
  enable_nat_gateway = local.enable_nat_gateway
  single_nat_gateway = local.single_nat_gateway


  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "${local.vpc_name}"
  }
}
