
provider "aws" { 
aws_access_key = "" 
aws_secret_key = ""
region = "us-east-1"
}

variable "envirement" {
type = string 
default = "dev" 
}

locals { 
instance_type == var.envirement == "prod" ? "t2.large"
              == var.envirement == "qa" ? "t2.medium"
                                        "t2.small"
}

resource "aws_instance" "prod_instance" {
ami = "xyz"/
instance_type = local.instance_type 
}


==============================================


variable "envirement" { 
    type = string 
    default = "dev" 
} 

locals { 
    instance_type = var.envirement == "prod" ? "t2.large" : "t2.micro" 
} 

resource "aws_instance" "ec2" { 
    ami = "ami-123" 
    instance_type = local.instance_type 
} 


