provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = "us-east-1"
}

resource "aws_vpc" "hannah-vpc-03" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "hannah-vpc-03"
  }
}

resource "aws_subnet" "public-03" {
  vpc_id                  = aws_vpc.hannah-vpc-03.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-03"
  }
}

resource "aws_subnet" "private-03" {
  vpc_id            = aws_vpc.hannah-vpc-03.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-03"
  }
}

resource "aws_internet_gateway" "hannah-ig-03" {
  vpc_id = aws_vpc.hannah-vpc-03.id
}

resource "aws_route_table" "public-route-table-03" {
  vpc_id = aws_vpc.hannah-vpc-03.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hannah-ig-03.id
  }
}

resource "aws_route_table_association" "public-route-table-03" {
  subnet_id      = aws_subnet.public-03.id
  route_table_id = aws_route_table.public-route-table-03.id
}

resource "aws_route_table" "private-route-table-03" {
  vpc_id = aws_vpc.hannah-vpc-03.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hannah-ig-03.id
  }
}

resource "aws_route_table_association" "private-route-table-03" {
  subnet_id      = aws_subnet.private-03.id
  route_table_id = aws_route_table.private-route-table-03.id
}

resource "aws_eip" "eip-03" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gateway-03" {
  allocation_id = aws_eip.eip-03.id
  subnet_id     = aws_subnet.public-03.id
}

resource "aws_security_group" "nat-sg-03" {
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.private-03.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private-route-table-03.id
  destination_cidr_block = "0.0.0.0/10"
  nat_gateway_id         = aws_nat_gateway.nat-gateway-03.id
}
