
provider "aws" {
    region = "us-east-1"
}

locals {
    instance_refs = {
        inst-1 = "instance-1"
        inst-2 = "instance-2"
        inst-3 = "instance-3"
    }
}

resource "aws_instance" "prod_instance" {
    for_each = local.instance_refs 
    name = "${local.instnace_refs}"-instance
    description = "prod instance" 
    instance_type = "t2.large" 
    ami = "ami-123" 
    tags= {
        name = eack.key 
    }

}