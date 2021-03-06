locals {
  create = var.create 
  
  is_t_instance_type = replace(var.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false
}


### EBS 0

resource "aws_instance" "private0" {
  count = local.create && var.priva > 0 && length(var.volume_size) == 1 && var.volume_size[0] < 1 ? var.priva : 0
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

  tags = merge(var.tags,{
    Name = "${var.vpc_name}-${var.service_name}-private-${count.index+1}"
   },
  )

  }

resource "aws_instance" "pub0" {
  count = local.create && var.pub > 0 && length(var.volume_size) == 1 && var.volume_size[0] < 1 ? var.pub : 0

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
  
 
  user_data = <<-EOT
  #!/bin/bash
  
   EOT
  
  tags = merge(var.tags,{
    Name = "${var.vpc_name}-${var.service_name}-public-${count.index+1}"
   },
  )

 }
 

#### EBS 1
resource "aws_instance" "private1" {
  count = local.create && var.priva > 0 && length(var.volume_size) == 1 && var.volume_size[0] > 0 ? var.priva : 0
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
  
 ebs_block_device {

 
   device_name =  var.device_name[0]
   volume_type = var.volume_type
   volume_size = var.volume_size[0]
   encrypted = var.encrypted
   delete_on_termination = true
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-private-ebs-1"
   },
  )
  
    }
 user_data = <<-EOT
  #!/bin/bash
    sudo mkfs -t ext4 /dev/sdb
  
    sudo mkdir /data1
 
    sudo mount /dev/sdb /data1
 
    echo '/dev/sdb /data1  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null

   EOT
  
  

  
  tags = merge(var.tags,{
    Name = "${var.vpc_name}-${var.service_name}-private-${count.index+1}"
   },
  )

  }

resource "aws_instance" "pub1" {
  count = local.create && var.pub > 0 && length(var.volume_size) == 1 && var.volume_size[0] > 0 ? var.pub : 0

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
  
 ebs_block_device {
   device_name = var.device_name[0]
   volume_type = var.volume_type
   volume_size =  var.volume_size[0]
   encrypted = var.encrypted
   delete_on_termination = true
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-pub-ebs-1"
   },
  )
  
    }

  user_data = <<-EOT
  #!/bin/bash
    sudo mkfs -t ext4 /dev/sdb
  
    sudo mkdir /data1
 
    sudo mount /dev/sdb /data1
 
    echo '/dev/sdb /data1  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null

   EOT
  
  tags = merge(var.tags,{
    Name = "${var.vpc_name}-${var.service_name}-public-${count.index+1}"
   },
  )

 }
 
 #### EBS 2

resource "aws_instance" "private2" {
  count = local.create && var.priva > 0 && length(var.volume_size) == 2 ? var.priva : 0
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
  
 ebs_block_device {

 
   device_name =  var.device_name[0]
   volume_type = var.volume_type
   volume_size = var.volume_size[0]
   encrypted = var.encrypted
   delete_on_termination = true
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-private-ebs-1"
   },
  )
  
    }
 
 ebs_block_device {
   device_name = var.device_name[1]
   volume_type = var.volume_type
   volume_size = var.volume_size[1]
   encrypted = var.encrypted
   delete_on_termination = true
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-private-ebs-2"
   },
  )
  
    }
 user_data = <<-EOT
  #!/bin/bash
    sudo mkfs -t ext4 /dev/sdb
    sudo mkfs -t ext4 /dev/sdc
  
    sudo mkdir /data1
    sudo mkdir /data2
 
    sudo mount /dev/sdb /data1
    sudo mount /dev/sdc /data2
 
    echo '/dev/sdb /data1  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null
    echo '/dev/sdc /data2  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null
   EOT
   
  
  tags = merge(var.tags,{
    Name = "${var.vpc_name}-${var.service_name}-private-${count.index+1}"
   },
  )

  }

resource "aws_instance" "pub2" {
  count = local.create && var.pub > 0 && length(var.volume_size) == 2 ? var.pub : 0

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
  
 ebs_block_device {
   device_name = var.device_name[0]
   volume_type = var.volume_type
   volume_size =  var.volume_size[0]
   encrypted = var.encrypted
   delete_on_termination = true
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-pub-ebs-1"
   },
  )
  
    }
 
  
 ebs_block_device {
   device_name = var.device_name[1]
   volume_type = var.volume_type
   volume_size = var.volume_size[1]
   encrypted = var.encrypted
   delete_on_termination = true
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-pub-ebs-2"
   },
  )
  
    }
 user_data = <<-EOT
  #!/bin/bash
    sudo mkfs -t ext4 /dev/sdb
    sudo mkfs -t ext4 /dev/sdc
  
    sudo mkdir /data1
    sudo mkdir /data2
 
    sudo mount /dev/sdb /data1
    sudo mount /dev/sdc /data2
 
    echo '/dev/sdb /data1  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null
    echo '/dev/sdc /data2  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null
   EOT
  
  tags = merge(var.tags,{
    Name = "${var.vpc_name}-${var.service_name}-public-${count.index+1}"
   },
  )

 }
 
 
 ### EBS 3

resource "aws_instance" "private3" {
  count = local.create && var.priva > 0 && length(var.volume_size) == 3 ? var.priva : 0
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
  
 ebs_block_device {

 
   device_name =  var.device_name[0]
   volume_type = var.volume_type
   volume_size = var.volume_size[0]
   encrypted = var.encrypted
   delete_on_termination = var.delete_on_termination
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-private-ebs-1"
   },
  )
  
    }
 
 ebs_block_device {
   device_name = var.device_name[1]
   volume_type = var.volume_type
   volume_size = var.volume_size[1]
   encrypted = var.encrypted
   delete_on_termination = var.delete_on_termination
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-private-ebs-2"
   },
  )
  
    }
 ebs_block_device {
   device_name = var.device_name[2]
   volume_type = var.volume_type
   volume_size = var.volume_size[2]
   encrypted = var.encrypted
   delete_on_termination = var.delete_on_termination
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-private-ebs-3"
   },
  )
  
    }  
  
  user_data = <<-EOT
  #!/bin/bash
    sudo mkfs -t ext4 /dev/sdb
    sudo mkfs -t ext4 /dev/sdc
    sudo mkfs -t ext4 /dev/sdd
    
    sudo mkdir /data1
    sudo mkdir /data2
    sudo mkdir /data3
    
    sudo mount /dev/sdb /data1
    sudo mount /dev/sdc /data2
    sudo mount /dev/sdd /data3
 
    echo '/dev/sdb /data1  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null
    echo '/dev/sdc /data2  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null
    echo '/dev/sdd /data3  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null
    
   EOT
   
  tags = merge(var.tags,{
    Name = "${var.vpc_name}-${var.service_name}-private-${count.index+1}"
   },
  )

  }

resource "aws_instance" "pub3" {
  count = local.create && var.pub > 0 && length(var.volume_size) == 3 ? var.pub : 0

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
  
 ebs_block_device {
   device_name = var.device_name[0]
   volume_type = var.volume_type
   volume_size =  var.volume_size[0]
   encrypted = var.encrypted
   delete_on_termination = var.delete_on_termination
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-pub-ebs-1"
   },
  )
  
    }
 
  
 ebs_block_device {
   device_name = var.device_name[1]
   volume_type = var.volume_type
   volume_size = var.volume_size[1]
   encrypted = var.encrypted
   delete_on_termination = var.delete_on_termination
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-pub-ebs-2"
   },
  )
  
    }
 ebs_block_device {
   device_name = var.device_name[2]
   volume_type = var.volume_type
   volume_size = var.volume_size[2]
   encrypted = var.encrypted
   delete_on_termination = var.delete_on_termination
   tags = merge(var.tags,{
        Name = "${var.vpc_name}-${var.service_name}-${count.index+1}-pub-ebs-3"
   },
  )
  
    }
  user_data = <<-EOT
  #!/bin/bash
    sudo mkfs -t ext4 /dev/sdb
    sudo mkfs -t ext4 /dev/sdc
    sudo mkfs -t ext4 /dev/sdd
    
    sudo mkdir /data1
    sudo mkdir /data2
    sudo mkdir /data3
    
    sudo mount /dev/sdb /data1
    sudo mount /dev/sdc /data2
    sudo mount /dev/sdd /data3
 
    echo '/dev/sdb /data1  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null
    echo '/dev/sdc /data2  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null
    echo '/dev/sdd /data3  ext4  defaults 0 0' | sudo  tee -a  /etc/fstab > /dev/null
    
   EOT
  tags = merge(var.tags,{
    Name = "${var.vpc_name}-${var.service_name}-public-${count.index+1}"
   },
  )

 }
 
 
 