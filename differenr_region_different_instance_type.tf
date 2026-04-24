
variable "envirement" {
type = string 
default = "dev"
}

locals {
instance_type = var.envirement == "prod" ? "t2.large"
                var.envirement == "prod" ? "t2.medium"
                                            "t2.small"    
                                                
                                                }




variable "ingress_rules" {
type = list(numbers)
default = [22,445.8080]
}

variable "egress_rules" {
type = list(number)
default = [8880,56444,54666]
}

resource "aws_security_group" "prod_security" {
name = "prod_security"
description = "provide prod ingress and "egress_rules"
dynamic {
for_each var.ingress_rules
interater = "prod_ingress"
content {
to_port = prod_ingress.value
from_port = prod_ingress.value
ptotocal = "TCP"
}}}