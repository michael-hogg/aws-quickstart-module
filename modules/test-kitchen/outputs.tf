output "vpc_id" {
  value = aws_vpc.test_kitchen_vpc.id
}

output "security_group_id" {
  value = aws_security_group.test_kitchen_security_group.id
}
