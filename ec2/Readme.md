### EC2 BASIC 구성하기 

구성도 

![ec2](../img/EC2.PNG)

### 구성에 필요한 정보는  사전에 작성된 vpc.output에서 변수 값으로 받아옴


>vpc 정보 확인 부분 
```bash
data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../vpc/terraform.tfstate"
  }
}
```

>사용자 입력 부분 
>> 주의사항 : ebs 생성시 용량이나 볼륨수를 pub와  priva를 다르게 가져가길 바랄경우 : 개별 실행
>> module부분에서는 EBS 볼륨수 만큼 RESOURCE (aws_instance) x 2 가 생성됨(public, private)
>> EBS MAX VOLUMES = 3

``` bash
### 사용자 입력 부분 ###


### 사용자 입력 부분 ###

locals {
  name   = "example-ec2-complete"
  region = "ap-northeast-2"
  vpc_name = "simple-vpc"
  service_name = "webserver"
  key_name = "cloud"
  ami = "ami-0e5732e0fc87ab42e"
  instance_type = "t2.micro"

  ########################################################################
  ## 생성할 instance 갯수 -> pub: public ec2, priva: private ec2
  pub = 1        
  priva = 0      
  
  ###  root volume 사이즈 (GB)
  root_volume_size = 20

  ## ebs volume 사이즈 (GB)
  ## LIST형으로 [0] 일 경우 생성하지 않음
  ## 예시 [10] -> 10GB EBS를 하나 생성 , [10,14] -> 10GB, 14GB 볼륨을 각각 하나씩 생성
  ## 하나의 resource "aws_instance" 안에서 동작 : mount 및 fstab 실행 [mount point : /data1,/data2,/data3]
  
  ebs_volume_size = [10,14,15] 
  
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

```

private = 1대, public = 1대 구성테스트 정상 완료 
