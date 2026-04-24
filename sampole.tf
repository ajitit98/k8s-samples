
variable "ingress_rule" {
    type = list(number) 
    default = [22,8080,443]
}

variable "egress_rule" {
    type = list(number) 
    default = [2322,5444,24333]
}

resource "aws_security_group" "prod_security" {
    name = "prod_security" 
    dynamic "ingress" {
        for_each = var.ingress_rule 
        intereter = inbound_port 
        content {
            to_port = inbound_port.value 
            from_port = inbound_port.value 
            protocal = "tcp" 
        }

    dynamic "egress_rule" {
        for_each = var.egress_rule 
        intereter = egress_port 
        contwent {
            to_port = egree_port.value 
            from_port = egress_port 
            protocal = "tcp" 
        }
    }    
    }
}