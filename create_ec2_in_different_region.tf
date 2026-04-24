
provider "aws" {
    region = "us-east-1"
    alias = "us-east" 
}

provider "aws" {
    region = "us-west-1"
    alias = "us-west" 
}

resource "aws_instance" "prod-east" {
    ami = "ami-123" 
    instance_type = "t2.micro" 
    provider = aws.us-east 
    tags ={
        name = "prod-us-instance"
    }
}

resource "aws_instance" "prod-west" {
    ami = "ami-234"
    instance_type = "t2.small"
    provider = aws.us-west
    tags = {
        name = "prod-us-est-instance" 
    }
}


