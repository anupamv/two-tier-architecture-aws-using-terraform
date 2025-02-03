resource "aws_security_group" "sg" {
  name        = var.sg-name
  description = "Allow tls for inbound traffic"
  vpc_id = aws_vpc.myvpc.id


  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb-sg.id]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_egress_rule" "example" {
  security_group_id = aws_security_group.db-sg.id
  
  cidr_ipv4   = "10.0.0.0/24"
  from_port   = 3306
  ip_protocol = "tcp"
  to_port     = 3306

