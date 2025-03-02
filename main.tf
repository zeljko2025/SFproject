terraform {

provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1a"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "public" {
  subnet_id   = aws_subnet.public.id
  private_ips = ["10.0.1.10"]
  security_groups = [aws_security_group.allow_ssh.id]
}

resource "aws_network_interface" "private" {
  subnet_id   = aws_subnet.private.id
  private_ips = ["10.0.2.10"]
  security_groups = [aws_security_group.allow_ssh.id]
}

resource "aws_security_group" "allow_port_9000" {
    name        = "allow_port_9000"
    description = "Allow inbound traffic on port 9000 from the internal device"
    vpc_id      = aws_vpc.main.id
  
    ingress {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      cidr_blocks = ["10.200.16.100/29"]
    }
  
    tags = {
      Name = "allow_port_9000"
    }


resource "aws_instance" "ubuntu_server" {
  ami           = "ami-0d49bd8a094867c99"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.public.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.private.id
    device_index         = 1
  }

  tags = {
    Name = "UbuntuVM"
  }
}
}