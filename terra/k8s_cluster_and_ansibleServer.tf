#aws cli config dic path
provider "aws" {
  shared_config_files      = ["/Users/tf_user/.aws/config"]
  shared_credentials_files = ["/Users/tf_user/.aws/credentials"]
  profile                  = "customprofile"
}

resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "k8s-cluster"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "main"
  }
  depends_on = [
    aws_vpc.my_vpc
  ]
}
resource "aws_route_table" "tf-route" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id             = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "k8s-ckuster-route"
  }
  depends_on = [
    aws_vpc.my_vpc
  ]
}

resource "aws_subnet" "tf-subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}
resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.tf-subnet.id
  route_table_id = aws_route_table.tf-route.id
}
resource "aws_security_group" "allow_web" {
  name        = "allow_k8s_cluster_traffic"
  description = "Allow k8s inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "K8S_Network_fannel"
    from_port        = 8285
    to_port          = 8285
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "K8S_Network_fannel"
    from_port        = 8472
    to_port          = 8472
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "K8S_cluster_service"
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "K8S_cluster_service"
    from_port        = 10257
    to_port          = 10257
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "K8S_cluster_service"
    from_port        = 10259
    to_port          = 10259
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "K8S_cluster_service"
    from_port        = 2379
    to_port          = 2379
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "K8S_cluster_service"
    from_port        = 2380
    to_port          = 2380
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "K8S_cluster_service"
    from_port        = 30000
    to_port          = 30000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "K8S_cluster_service"
    from_port        = 6443
    to_port          = 6443 
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "K8S_cluster_service"
    from_port        = 32767
    to_port          = 32767
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_k8s_cluster_traffic"
  }
}
resource "aws_network_interface" "tf-web-server-nic" {
  subnet_id       = aws_subnet.tf-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}
resource "aws_eip" "tf-eip" {
  vpc                       = true
  network_interface         = aws_network_interface.tf-web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw]
}
resource "aws_network_interface" "tf-web-server-nic1" {
  subnet_id       = aws_subnet.tf-subnet.id
  private_ips     = ["10.0.1.51"]
  security_groups = [aws_security_group.allow_web.id]
}
resource "aws_eip" "tf-eip1" {
  vpc                       = true
  network_interface         = aws_network_interface.tf-web-server-nic1.id
  associate_with_private_ip = "10.0.1.51"
  depends_on = [aws_internet_gateway.gw]
}
resource "aws_network_interface" "tf-web-server-nic2" {
  subnet_id       = aws_subnet.tf-subnet.id
  private_ips     = ["10.0.1.52"]
  security_groups = [aws_security_group.allow_web.id]
}
resource "aws_eip" "tf-eip2" {
  vpc                       = true
  network_interface         = aws_network_interface.tf-web-server-nic2.id
  associate_with_private_ip = "10.0.1.52"
  depends_on = [aws_internet_gateway.gw]
}
resource "aws_network_interface" "tf-web-server-nic3" {
  subnet_id       = aws_subnet.tf-subnet.id
  private_ips     = ["10.0.1.53"]
  security_groups = [aws_security_group.allow_web.id]
}
resource "aws_eip" "tf-eip3" {
  vpc                       = true
  network_interface         = aws_network_interface.tf-web-server-nic3.id
  associate_with_private_ip = "10.0.1.53"
  depends_on = [aws_internet_gateway.gw]
}
resource "aws_instance" "web" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "ec2"
  user_data = <<EOF
                  #! /bin/bash
                  sudo su
                  yum update -y
                  useradd -m "admin"
                  echo 1q1qas12 | passwd admin --stdin
                  echo "admin ALL=(ALL) NOPASSWD: ALL" >>  /etc/sudoers
                  EOF
  network_interface {
      device_index         = 0
      network_interface_id = aws_network_interface.tf-web-server-nic.id
  }
  tags = {
    Name = "Wroker"
  }
}
resource "aws_instance" "web1" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "ec2"
  user_data = <<EOF
                  #! /bin/bash
                  sudo su
                  yum update -y
                  useradd -m "admin"
                  echo 1q1qas12 | passwd admin --stdin
                  echo "admin ALL=(ALL) NOPASSWD: ALL" >>  /etc/sudoers
                  EOF
  network_interface {
      device_index         = 0
      network_interface_id = aws_network_interface.tf-web-server-nic1.id
  }
  tags = {
    Name = "Worker"
  }
}
resource "aws_instance" "web2" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "ec2"
  user_data = <<EOF
                  #! /bin/bash
                  sudo su
                  yum update -y
                  useradd -m "admin"
                  echo 1q1qas12 | passwd admin --stdin
                  echo "admin ALL=(ALL) NOPASSWD: ALL" >>  /etc/sudoers
                  EOF
  network_interface {
      device_index         = 0
      network_interface_id = aws_network_interface.tf-web-server-nic2.id
  }
  tags = {
    Name = "Master"
  }
}
resource "aws_instance" "web3" {
  ami           = "ami-0b8d6d0ec39cc4937"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "ec2"
  user_data = <<EOF
                  #! /bin/bash
                  sudo su
                  yum update -y
                  useradd -m "admin"
                  echo 1q1qas12 | passwd admin --stdin
                  echo "admin ALL=(ALL) NOPASSWD: ALL" >>  /etc/sudoers
                  yum install pip -y
                  yum install python3 -y
                  pip3 install boto3 -y
                  pip3 install ansible -y
                  EOF
  network_interface {
      device_index         = 0
      network_interface_id = aws_network_interface.tf-web-server-nic3.id
  }
  tags = {
    Name = "Ansible-k8s"
  }
}
