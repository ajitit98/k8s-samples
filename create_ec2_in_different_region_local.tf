
locals {
    region = {
        us = {
            region = "us-east-1"
            ami = "ami-123" 
        }
     }

       india = {
           region = "us-west-1"
           ami = "ami-234"
       }
}

provider "aws" {
    region = local.region.us.region 
    alias = "us" 
}

provider "aws" {
    region = local.region.india.region 
    alias = "india" 
}

resources "aws_instance" "us-instance" {
    ami = local.region.us.ami 
    instance_type = "t2.samll" 
    name = "prod-us-intance" 
    region = aws.us 
}

resource "aws_instance" "india-instance" {
    ami = local.region.india.ami 
    instance_type = "t2.large" 
    name = "prod-india-instance" 
    region = aws.india 
    
}


locals {
    region = {
        us = {
            region = "us-east-1" 
            ami = "ami-123"
        }
    }
    region = {
        india = {
            region = "us-west-2"
            ami = "ami-345"
        }
    }
}

provider "aws" {
    region = local.region.us.region 
    alias = ""us" 
}

provider "aws" { 
    region = local.region.india.region
    alias = "india" 
}