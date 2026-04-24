variable "instance_type" {
  description = "Specifies the EC2 instance type (t2.micro for dev, t2.large for prod)."
  type        = string
  default     = "t2.micro"   # default can be overridden via tfvars or CLI
}

variable "ami_id" {
  description = "AMI ID to launch"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # use a valid AMI for your region
}

locals {
  # Determine environment based on instance_type
  environment = var.instance_type == "t2.micro" ? "dev" : 
                var.instance_type == "t2.large" ? "prod" : "other"

  # Tags to use for the instance
  common_tags = {
    Name        = "${local.environment}-instance"
    Environment = local.environment
  }
}

resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # basic tags using locals
  tags = local.common_tags
}




========================================



variable "instance_type" {
    type = string 
    default = "qa"
}

variable "ami_id" {
    type = string 
    default = "ami-123"
}

locals { 
    Envirement = var.instance_type == "prod" ? "t2.large" 
                 var.instance_type == "dev"  ? "t2.small"

   tage = {
    Name = "${local.Envirement}"-instance 
    Envirement = local.Envirement
   }              
}

resource "ec2_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instanc_type 
    
}
=================================================

