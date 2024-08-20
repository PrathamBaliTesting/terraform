variable "vpc_region" {
  default     = "us-east-1"
  description = "AWS Region"
}


variable "vpc_cidr" {
  description = "VPC CIDR Block"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
  default = "10.0.1.0/16"
}

variable "private_subnet_cidr" {
  description = "Private Subnet CIDR"
  default = "10.0.2.0/16"
}

