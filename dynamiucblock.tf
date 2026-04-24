
variable "ingress_rules" { 
    type = list(number)
    default = [80,443,8080]
}

variable "egress_rules" {
    type = list(number)
    default = [433,6555,34545]

}

resource "aws_security_group" "prod_security" {
    name = "prod_security" 
    description = "security for porod servers" 
    dynamic "ingress" {
        for_each = var.ingress_rules
        interator = ingress_port 
        content { 
            from_port = ingress_port.value 
            to_port = ingress_port.value 
            protocol = "tcp"
        }

        dynamic "egress" {
            for_each = var.egress_rules 
            interator = egress_port 
            content {
                from_port = egress_port.value 
                to_port = egress_port.value 
                protocal = "tcp" 
            }
        }
    }
}

====================================================
provider "aws" {
    region = "us-east-1"
}

variable "ingress_prod" {
    type = list(number) 
    default = [22,443,8080]
}

variable "egress_prod" {
    type = list(number) 
    default = [3309,1106,3345]
}

resource "aws_security_group" "prod_security" {
    name = "prod-security_group" 
    description = "allow inbound and outbound traffic to prod instance" 
    dynamic "ingress" {
        for_each = var.ingress_prod 
        intereter = ingress_ports 
        content = {
            to_poort = ingress_port.value 
            from_port = ingress_port.value 
            protocal = "tcp" 
        }

        dynamic "egress" {
            for_each = var.egress_prod 
            intereter = egress_port 
            content = {
                to_port = egress_port.value
                from_port = egress_port.value 
                protocal = "tcp" 
            }
            }
        }
    }
}

