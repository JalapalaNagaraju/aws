output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = aws_subnet.subnet.*.id
}

output "internal_sg" {
  value = aws_security_group.internal-securitygroup.id
}

output "elb_sg" {
  value = aws_security_group.elb-sgz.id
}