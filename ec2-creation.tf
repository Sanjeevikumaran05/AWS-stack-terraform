provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.subnet_availability_zone
  map_public_ip_on_launch = true
}

resource "aws_security_group" "web-server-sg" {
  name        = "web-server-sg"
  description = "Allow incoming SSH, HTTP, and HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.http_cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.https_cidr_blocks
  }
}

resource "aws_instance" "web" {
  ami                         = "ami-0261755bbcb8c4a84" # Ubuntu 20.04 LTS AMI ID
  instance_type               = "t2.micro"
  key_name                    = "sans"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web-server-sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("${path.module}/private-key/sans.pem")
  }
}

resource "aws_eip" "ec2_eip" {
  instance = aws_instance.web.id
}

output "public_ip" {
  value = aws_eip.ec2_eip.public_ip
}

