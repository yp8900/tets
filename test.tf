provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAYMLXYPUAJ5BPFMNX"
  secret_key = "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"
}
resource "aws_instance" "web" {
  ami           = "ami-02e94b011299ef128"
  instance_type = "t2.micro"
  key_name 	= "cloud"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
 tags = {
        name = "newmachine"
}
}

resource "aws_key_pair" "deployer" {
  key_name   = "cloud"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpCbhey7GD8mnqOUkZuDP09kh/4mBjNkFnjTm9VCtTf/X09/Fli7TD2fbq9JG6DG2j3zvCOFJd7T565J2XyM4zpccake3/LBMwFgEV1giPYvDmT6S9rdb8PMWL4HMsWgAGaL4MNN2ZU4JteX1/r+4HmeaHJn7fxXB7qbbXSqRJfMKtQ3QqOi3PSG9vHktVkaN65iZ4fVoqVCjaEZjBQeo+tjgeHOCRksgzMARwCttoDgnzH03mMPELOYqt1dataIYnDZzUq50I7cMJ7ODZp76ZoCcchKlbMZvPML7wEuuN314TMfbL/j2Vl3HY6Hb/zecdG3+dolqxl+BKs7h4jWqx root@ip-172-31-39-140.ap-south-1.compute.internal"
}

resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  domain   = "vpc"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
      }

  egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}	



