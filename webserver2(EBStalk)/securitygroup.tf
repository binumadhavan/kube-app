// security group for elastic beans, prod web servers, bastion host and backend servers like mysql, rabbitmq and elastic cache

resource "aws_security_group" "sg_elbeans" {
  name        = "sg_elbeans"
  description = "sg for elastic beans"
  vpc_id      = module.vpc.vpc_id

  ingress {
    #description      = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_elbeans"
  }
}
resource "aws_security_group" "bastionhostsg" {
  name        = "bastionhostsg"
  description = "sg for bastionhost"
  vpc_id      = module.vpc.vpc_id

  ingress {
    #description      = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["27.7.120.222/32"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bastionhostsg"
  }
}
resource "aws_security_group" "prodsg" {
  name        = "prodsg"
  description = "sg for webserver"
  vpc_id      = module.vpc.vpc_id

  ingress {
    #description      = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.bastionhostsg.id]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "prodwebserversg"
  }
}

resource "aws_security_group" "backendsg" {
  name        = "backendsg"
  description = "sg for backend for rabbitmq, elastic cache and mysql"
  vpc_id      = module.vpc.vpc_id

  ingress {
    #description      = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.prodsg.id]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "backendsg"
  }
}

resource "aws_security_group_rule" "itself" {
  type      = "ingress"
  from_port = 0
  to_port   = 65535
  protocol  = "tcp"
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id        = aws_security_group.backendsg.id
  source_security_group_id = aws_security_group.backendsg.id
}