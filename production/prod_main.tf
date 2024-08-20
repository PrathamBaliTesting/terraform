provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "production" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "production-be"
  }
}

# Public Subnet
resource "aws_subnet" "public-subnet" {
  cidr_block        = var.public_subnet_cidr
  vpc_id            = aws_vpc.production.id
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "production-be-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private-subnet" {
  cidr_block        = var.private_subnet_cidr
  vpc_id            = aws_vpc.production.id
  availability_zone = "us-east-1b"
  tags = {
    Name = "production-be-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = "production-be-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = "production-be-public-rt"
  }
}

# Route for Public Subnet to Internet
resource "aws_route" "public-internet-gw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.production-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public-subnet-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet.id
}

# Private Route Table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = "production-be-private-rt"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "production-be-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet.id
  tags = {
    Name = "production-be-nat-gw"
  }
  depends_on = [aws_eip.eip]
}

# Route for Private Subnet to NAT Gateway
resource "aws_route" "nat-gw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Associate Private Subnet with Route Table
resource "aws_route_table_association" "private-subnet-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet.id
}

# Security Group for Backend Instances
resource "aws_security_group" "backend_sg" {
  vpc_id = aws_vpc.production.id
  name   = "production-be-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production-be-sg"
  }
}
