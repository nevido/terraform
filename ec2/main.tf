provider "aws" {
  region = local.region
}


data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../vpc/terraform.tfstate"
  }
}

### 사용자 입력 부분 ###

locals {
  name   = "example-ec2-complete"
  region = "ap-northeast-2"
  vpc_name = "simple-vpc"
  service_name = "webserver"
  key_name = "cloud"
  ami = "ami-0e5732e0fc87ab42e"
  instance_type = "t2.micro"
  pub = 0          # public 에 생성할 서버 수량
  priva = 1         # private에 생성할 서버 수량
  owner = "jaeyonglee"
  team = "infra-1"
  
  
  
  ######### Don't touch #######################################
  public_sub =  data.terraform_remote_state.vpc.outputs.public_subnets
  private_sub = data.terraform_remote_state.vpc.outputs.private_subnets
  database_sub = data.terraform_remote_state.vpc.outputs.database_subnets
  security_group_default = data.terraform_remote_state.vpc.outputs.default_security_group_id
  azs = data.terraform_remote_state.vpc.outputs.azs
  user_data = <<-EOT
  #!/bin/bash
  echo "will make script or file after"
  EOT


}



module "ec2_instance" {
  source = "../modules/ec2"
  name = "single-instance"
  ami = local.ami
  instance_type = local.instance_type
  key_name = local.key_name
  monitoring = "true"
  public_subnets = local.public_sub
  private_subnets = local.private_sub
  database_subnets = local.database_sub
  security_group_default = local.security_group_default
  pub = local.pub
  priva = local.priva
  azs = local.azs
  vpc_name = local.vpc_name
  service_name = local.service_name
  
  
  root_block_device = [
   {
       volume_type = "gp2"
       volume_size = 20
       encrypted   = true
      # tags = {
      #   Name ="${local.vpc_name}-${local.service_name}-root_block_device"
        
      # }
   },
  ]
  tags = {
   Terraform = local.owner
   Environment = local.team
 }
}


### output test #################

# output "test" {
#   value = data.terraform_remote_state.vpc.outputs.private_subnets
# }

# output "security_group" {
#   value = data.terraform_remote_state.vpc.outputs.default_security_group_id
# }

# output "azs" {
#   value = data.terraform_remote_state.vpc.outputs.azs
# }