resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Esmael_VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block             = var.public_subnet_cidrs[0]
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name[0]
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[0]
  tags = {
    Name = var.subnet_name[2]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main_igw"
  }
}

resource "aws_eip" "nat_eip" {
   domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "Esmael_nat_gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Esmael_public_route_table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "Esmael_private_route_table"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "apache_sg" {
  name        = "Esmael_apache_sg"
  description = "Allow inbound HTTP and SSH"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "Esmael_apache_sg"
  }
}

resource "aws_instance" "Esmael_apache_ec2_public" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.apache_sg.id]
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y apache2
    echo "Welcome to Esmael's Public instance - IP: $(hostname -I)" > /var/www/html/index.html
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo systemctl restart apache2
  EOF
  key_name                    = aws_key_pair.esmael_keypair.key_name
  tags = {
    Name = "Esmael_apache_ec2_public"
  }
}

resource "aws_instance" "Esmael_apache_ec2_private" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = [aws_security_group.apache_sg.id]
  associate_public_ip_address = false
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y apache2
    echo "Welcome to Esmael's Private instance - IP: $(hostname -I)" > /var/www/html/index.html
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo systemctl restart apache2
  EOF
  key_name                    = aws_key_pair.esmael_keypair.key_name
  tags = {
    Name = "Esmael_apache_ec2_private"
  }
}

