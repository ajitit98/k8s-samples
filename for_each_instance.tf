 
provider "aws" {
    region = "us-east-1" 
}

locals {
instance_ref= {
   inst1 = "instance-1"
   inst1 = "instance-2"
   inst1 = "instance-3"
   inst1 = "instance-4"
}
}

resource "aws_instance" "prod_instance" {
    name = "${local.instance_ref}"-instance
    for_each = local.instance_ref 
    ami = "ami-123" 
    instance_type = "t2.large" 
    tags = {
        name = each.key 
    }
}

================================

provider "aws"{
    region = "us-east-1" 
}

locals { 
    instance_refs = {
        inst1 = "instance-01"
        inst2 = "instance-02"
    }
}

resource "aws_instance" "ec2" { 
    name = "prod_instance" 
    for_each = local.instance_refs 
    instance_type = "t2.micro" 
} 
