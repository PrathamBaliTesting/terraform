variable "vpc_region" {
  default     = "us-east-1"
  description = "AWS Region"
}


variable "vpc_cidr" {
  description = "VPC CIDR Block"
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
}

variable "private_subnet_cidr" {
  description = "Private Subnet CIDR"
}

