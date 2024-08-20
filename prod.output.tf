output "vpc_id" {
  value = aws_vpc.production.id
}
output "vpc_cidr_block" {
  value = aws_vpc.production.cidr_block
}
output "public_subnet_id" {
  value = aws_subnet.public-subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private-subnet.id
}

output "backend_security_group_id" {
  value = aws_security_group.backend_sg.id
}