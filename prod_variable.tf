variable "vpc_region" {
  default     = "us-east-1"
  description = "AWS Region"
}


variable "prod_vpc_cidr" {
  description = "VPC CIDR Block"
}

variable "prod_public_subnet_cidr" {
  description = "Public Subnet CIDR"
}

variable "prod_private_subnet_cidr" {
  description = "Private Subnet CIDR"
}

