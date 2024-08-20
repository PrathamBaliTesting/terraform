
variable "vpc_cidr" {
  description = "VPC CIDR Block"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private Subnet CIDR"
  default = "10.0.2.0/24" 
}

variable "availability_zone" {
  description = "Availability Zone for the development environment"
  type        = string
  default     = "us-east-1a"  # Update as needed
}

