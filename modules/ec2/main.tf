locals {
  create = var.create 

  is_t_instance_type = replace(var.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false
}




resource "aws_instance" "private" {
  count = local.create && var.priva > 0 ? var.priva : 0
  ami                  = var.ami
  instance_type        = var.instance_type

  availability_zone      = element(var.azs,count.index)
  vpc_security_group_ids =  ["${var.security_group_default}"]
  subnet_id = element(var.private_subnets,count.index)
  key_name             = var.key_name
  monitoring           = var.monitoring

  }
  
resource "aws_instance" "pub" {
  count = local.create && var.pub > 0 ? var.pub : 0

  ami                  = var.ami
  instance_type        = var.instance_type


  availability_zone      = element(var.azs,count.index)
  vpc_security_group_ids =  ["${var.security_group_default}"]
  subnet_id = element(var.public_subnets,count.index)
  key_name             = var.key_name
  monitoring           = var.monitoring

  }
  
