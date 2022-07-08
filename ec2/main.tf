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
  
  ## public 과 private 서버의 disk 용량을 다르게 하고 싶을경우는 개별로 돌려주세요
  #첫번째 pub = 0, priva = 1
  #두번재 pub = 1, private = 0
  ########################################################################
  pub = 1          # public 에 생성할 서버 수량
  priva = 0      # private에 생성할 서버 수량
  root_volume_size = 20
 # ebs_volume_count = 2   #볼륨 수
  
  ebs_volume_size = [10,14,15]  #example [10,15,20]
  #   source = "../modules/ec2/two" 수정 ~/one ~/tow
  owner = "jaeyonglee"
  team = "infra-1"


  ######### Don't touch #######################################
  public_sub =  data.terraform_remote_state.vpc.outputs.public_subnets
  private_sub = data.terraform_remote_state.vpc.outputs.private_subnets
  database_sub = data.terraform_remote_state.vpc.outputs.database_subnets
  security_group_default = data.terraform_remote_state.vpc.outputs.default_security_group_id
  azs = data.terraform_remote_state.vpc.outputs.azs
  volume_num = 2
}



module "ec2_instance" {
  source = "../modules/ec2/one"
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
       volume_size = local.root_volume_size
       encrypted   = true
       delete_on_termination = true
      # tags = {
      #   Name ="${local.vpc_name}-${local.service_name}-root_block_device"
        
      # }
   },
  ]
  
  delete_on_termination = true
  encrypted   = true
       
  volume_type = "standard"

  volume_size = local.ebs_volume_size
  device_name = ["/dev/sdb","/dev/sdc","/dev/sdd"]
  tags = {
   Terraform = local.owner
   Environment = local.team
 }
}


