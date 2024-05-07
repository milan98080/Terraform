resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = "${each.key}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main Internet Gateway"
  }
}

resource "aws_eip" "nat" {
  for_each = { for k, v in var.subnets : k => v if v.public }
}

resource "aws_nat_gateway" "nat" {
  for_each = { for k, v in aws_subnet.subnets : k => v if v.map_public_ip_on_launch }

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "NAT Gateway ${each.key}"
  }
}

resource "aws_route_table" "public" {
  for_each = { for k, v in aws_subnet.subnets : k => v if v.map_public_ip_on_launch }

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table ${each.key}"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_route_table.public

  subnet_id      = each.value.id
  route_table_id = each.value.id
}

resource "aws_route_table" "private" {
  for_each = { for k, v in aws_subnet.subnets : k => v if !v.map_public_ip_on_launch }

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[replace(each.key, "private_", "public_")].id
  }

  tags = {
    Name = "Private Route Table ${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_route_table.private

  subnet_id      = each.value.id
  route_table_id = each.value.id
}