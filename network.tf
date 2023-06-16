provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
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
resource "aws_subnet" "public-04" {
  vpc_id                  = aws_vpc.hannah-vpc-03.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-04"
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
resource "aws_subnet" "private-04" {
  vpc_id            = aws_vpc.hannah-vpc-03.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-04"
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

# Create Security Group
resource "aws_security_group" "SG-01" {
  vpc_id = aws_vpc.hannah-vpc-03.id

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

  tags = {
    Name = "alb-security-group"
  }
}


# Create Auto Scaling Group (ASG) and Launch Template
resource "aws_launch_template" "sample_launch_template" {
  name          = "smple_launch_template"
  description   = "A launch template for my web server"
  image_id      = "ami-022e1a32d3f742bd8"
  instance_type = "t2.micro"
  # security_groups = [aws_security_group.SG-01.id]

  user_data = base64encode(<<EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    service httpd start
    chkconfig httpd on
    echo "<html><body><h1>Welcome to my Second web server!</h1></body></html>" > /var/www/html/index.html
  EOF
  )
}


resource "aws_autoscaling_group" "sample_autoscaling_group" {
  name_prefix = "sample-asg-"
  # launch_template           = aws_launch_template.sample_launch_template.id

  launch_template {
    id = aws_launch_template.sample_launch_template.id
  }

  min_size                  = 2
  max_size                  = 2
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.private-03.id, aws_subnet.private-04.id]
  health_check_type         = "EC2"
  health_check_grace_period = 300
  termination_policies      = ["Default"]

  tag {
    key                 = "Name"
    value               = "example-instance"
    propagate_at_launch = true
  }
}

# Create Application Load Balancer (ALB)
resource "aws_lb" "sample_alb" {
  name               = "sample-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG-01.id]
  subnets            = [aws_subnet.public-03.id, aws_subnet.public-04.id]

  tags = {
    Name = "sample-alb"
  }
}

resource "aws_lb_target_group" "sample_target_group" {
  name        = "sample-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.hannah-vpc-03.id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "sample_listener" {
  load_balancer_arn = aws_lb.sample_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sample_target_group.arn
  }
}

# Test the setup
# After applying the Terraform configuration, you can test the web server's accessibility by accessing the ALB's DNS name in a web browser.








