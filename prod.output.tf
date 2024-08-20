output "vpc_id" {
  value = aws_vpc.production.id
}
output "vpc_cidr_block" {
  value = aws_vpc.production.cidr_block
}
output "public_subnet_id" {
  value = prod_aws_subnet.public-subnet-1.id
}

output "private_subnet_id" {
  value = prod_aws_subnet.private-subnet-1.id
}
