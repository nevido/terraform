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
  
  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      # iops                  = lookup(root_block_device.value, "iops", null)
      # kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      # throughput            = lookup(root_block_device.value, "throughput", null)
      # tags                  = lookup(root_block_device.value, "tags", null)
      tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-private-root-device"
   },
  )
  
    }
  }
  
  
 dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      # iops                  = lookup(ebs_block_device.value, "iops", null)
      # kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      # snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      # throughput            = lookup(ebs_block_device.value, "throughput", null) 
      tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-private-ebs-device"
   },
  )
  
    }
  }
  
  tags = merge(var.tags,{
    Name = "${var.vpc_name}-${var.service_name}-private-${count.index+1}"
   },
  )

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
 dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      # iops                  = lookup(root_block_device.value, "iops", null)
      # kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      # throughput            = lookup(root_block_device.value, "throughput", null)
      # tags                  = lookup(root_block_device.value, "tags", null)
      tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-public-root-device"
   },
  )
  
    }
  }
  
  
 dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      # iops                  = lookup(ebs_block_device.value, "iops", null)
      # kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      # snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      # throughput            = lookup(ebs_block_device.value, "throughput", null) 
      tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-public-ebs-device"
   },
  )
  
    }
  }
   
  user_data = <<-EOT
  #!/bin/bash
    sudo mkfs -t ext4 /dev/sdb
    sudo mkdir /data
    sudo mount /dev/sdb /data
   EOT
  
  tags = merge(var.tags,{
    Name = "${var.vpc_name}-${var.service_name}-public-${count.index+1}"
   },
  )

 }