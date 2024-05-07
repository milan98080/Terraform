output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.subnets : s.id if s.map_public_ip_on_launch]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.subnets : s.id if !s.map_public_ip_on_launch]
}

output "public_rt_s3_endpoint" {
  value = aws_route_table.public["public_subnet_3"].id
}


