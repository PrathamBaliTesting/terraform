
provider "aws" {
  region = var.vpc_region
}


resource "aws_vpc" "production" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "Production"
  }
}

#Public Subnet

resource "aws_subnet" "public-subnet" {
  cidr_block = var.public_subnet_cidr
  vpc_id     = aws_vpc.production.id
  availability_zone = "us-east-1"
  tags = {
    Name = "Public-Subent"
  }
}

#Private Subnet
resource "aws_subnet" "private-subnet" {
  cidr_block = var.private_subnet_cidr
  vpc_id     = aws_vpc.production.id
  availability_zone = "us-east-1"
  tags = {
    Name = "Private-Subent"
  }
}

#public rt

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = "Public-Route-Table"
  }
}

#private rt
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = "Private-Route-Table"
  }
}

#asso public subnet with rt
resource "aws_route_table_association" "public-subnet-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet.id
}

#asso private subnet with rt
resource "aws_route_table_association" "private-subnet-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet.id
}

#elastic IP
resource "aws_eip" "eip" {
  domain= "vpc"
  associate_with_private_ip = "10.0.2.0/16"
  tags = {
    Name = "Production-EIP"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet.id
  tags = {
    Name = "Production-NAT-GW"
  }
  depends_on = [aws_eip.eip]
}

resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = "Production-IGW"
  }
}

resource "aws_route" "public-internet-gw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.production-igw.id
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route" "nat-gw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}
