
provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "prod_vpc"{
    name = "prod_vpc"
    description = "provide network for prod instances" 
    cidr_block = "192.168.0.0/16"
    tags{
        name = "prod_us-east-vpc"
    }
} 

resource "aws_subnet" "public_subnet" {
    name = "prod_network_instance_public"
    description = "provide public access to public" 
    cidr_block = "192.168.1.0/32"
    vpc_id = aws_vpc.prod_vpc.id 
    map_public_ip_on_lounch = true 

    tags{
        name = "prod public subnet" 
    }
}

resource "aws_subnet" "private_subnet" { 
    name = "prod_private_subnet" 
    description = "provide network access to private" 
    cidr_block = "992.168.2.0/32"
    vpc_id = aws_vpc.prod_vpc.id 
    map_public_ip_on_lounch = false 

}



=====================================

provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "dev-vpc" {
    name = "dev-vpc" 
    description = "vpc for dev envirement" 
    cidr_block = "192.168.0.0/16"
    tags = {
        name = "dev-vpc-east-1" 
    }
}

resource "aws_subnet" "dev-public-sub" {
    name = "dev public subnet" 
    description = "provide ip for dev instances"
    cidr = "192.168.1.0/32"
    vpc_id =aws_vpc.dev_vpc.id
    map_public_ip_on_lounch = true 
    tage = {
        name = "dev-public-subnet"
    }
}


resource "aws_subnet" "dev-private-sub"  {
    name = "dev private subnet"
    description = "provide private ip for dev instancers" 
    cidr_block = "192.168.2.0/32"
    vpc_id = aws_vpc.dev-vpc.id 
    map_public_ip_on_lounch = false 
    tags = {
        name = "dev-private-subnet" 
    }
}