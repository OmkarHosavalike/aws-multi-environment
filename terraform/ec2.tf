resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id
  description = "Allow HTTP and SSH"
  name = "${local.name_prefix}-web-sg"

  tags = {
    Environment = local.environment
    Name = "${local.name_prefix}-web-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "allOut" {
  security_group_id = aws_security_group.web_sg.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
  description = "Allow all outbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allowHTTP" {
  security_group_id = aws_security_group.web_sg.id
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  description = "Allot http from everywhere"
}

resource "aws_vpc_security_group_ingress_rule" "allowSSH" {
  security_group_id = aws_security_group.web_sg.id
  ip_protocol = "tcp"
  cidr_ipv4 = "${chomp(data.http.myip.response_body)}/32"
  from_port = 22
  to_port = 22
  description = "Allow SSH from my IP"
}

resource "tls_private_key" "web_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "aws_key_pair" "web_key_pair" {
  key_name = "${local.name_prefix}-key"
  public_key = tls_private_key.web_key.public_key_openssh

  tags = {
    Name = "${local.name_prefix}-key"
    Environment = local.environment
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = aws_key_pair.web_key_pair.key_name
  subnet_id = aws_subnet.public[count.index].id
  count = length(aws_subnet.public)
  vpc_security_group_ids = [ aws_security_group.web_sg.id ]

  tags = {
    Name = "${local.name_prefix}-webinstance-${count.index + 1}"
    Environment = local.environment
  }
}

data "http" "myip" {
  url = "https://checkip.amazonaws.com"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}