terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws" 
            version = "=4.1.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

variable "ingress_rule" {
    description = "prod ingress port"
    type = list(number) 
    default = [8080,8081]
}

variable "egress_rule" {
    description = "prod egress port" 
    type = list(number)
    default  = [9090,9091]
}

resource "aws_security_group" "prod_sg" {
    name = "prod_sg" 
    dynamic "ingress" {
        for_each = var.ingress_rule 
        iterater = ingress
        content {
            to_port = var.ingress 
            from_port = var.ingress 
            protocal = "Tcp" 
            cidr_block = ["0.0.0.0/0"]
        }
    dynamic "egress" {
        for_each = var.egress_rule 
        iterater = egress
        content {
            to_port = var.egress 
            from_port = var.egress 
            protocal = "Tcp" 
            cidr_block = ["0.0.0.0/0"] 
        }
    }
    }
}