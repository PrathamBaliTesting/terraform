
provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "production" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "Production"
  }
}

#Public Subnet

resource "aws_subnet" "public-subnet" {
  cidr_block = var.public_subnet_cidr
  vpc_id     = aws_vpc.production.id
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone
  
  
  tags = {
    Name = "Public-Subent"
  }
}

#Private Subnet
resource "aws_subnet" "private-subnet" {
  cidr_block = var.private_subnet_cidr
  vpc_id     = aws_vpc.production.id
  availability_zone = var.availability_zone
  
  tags = {
    Name = "Private-Subent"
  }
}

# Public Route Table

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = "Public-Route-Table"
  }
}

# Private Route Table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = "Private-Route-Table"
  }
}

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public-subnet-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet.id
}

# Associate Private Subnet with Route Table
resource "aws_route_table_association" "private-subnet-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "eip" {
  domain= "vpc"
  associate_with_private_ip = "10.0.2.0/16"
  tags = {
    Name = "Production-EIP"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet.id
  tags = {
    Name = "Production-NAT-GW"
  }
  depends_on = [aws_eip.eip]
}

# Internet Gateway
resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = "Production-IGW"
  }
}

# Route for Public Subnet to Internet
resource "aws_route" "public-internet-gw-route" {
  route_table_id = aws_route_table.public-route-table.id
  gateway_id = aws_internet_gateway.production-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Route for Private Subnet to NAT Gateway
resource "aws_route" "nat-gw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Security Group for Backend Instances
resource "aws_security_group" "backend_sg" {
  vpc_id = aws_vpc.production.id
  name   = "backend-sg"

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
    Name = "Backend-SG"
  }
}

