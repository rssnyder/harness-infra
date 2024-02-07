resource "aws_iam_policy" "instance" {
  name        = "riley_instance"
  description = "Policy for rileys ec2 instances"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Sid": "GetArtifacts",
           "Effect": "Allow",
           "Action": [
               "s3:*"
           ],
           "Resource": [
              "${aws_s3_bucket.riley-snyder-harness-io.arn}",
              "${aws_s3_bucket.riley-snyder-harness-io.arn}/*"
           ]
       }
   ]
}
EOF
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.sa-lab.id

  ingress {
    description = "Open SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_random" {
  name        = "allow_random"
  description = "Allow random inbound traffic"
  vpc_id      = data.aws_vpc.sa-lab.id

  ingress {
    description = "Open Random"
    from_port   = 49152
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_random"
  }
}

resource "aws_security_group" "instance" {
  name        = "instance"
  description = "Allow traffic for harness"
  vpc_id      = data.aws_vpc.sa-lab.id

  ingress {
    description     = "vpc sg"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [data.aws_security_group.sa-lab-default.id]
  }

  ingress {
    description = "vpc cidr"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.sa-lab.cidr_block]
  }

  ingress {
    description = "drone"
    from_port   = 9079
    to_port     = 9079
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.sa-lab.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow traffic for websites"
  vpc_id      = data.aws_vpc.sa-lab.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

# resource "aws_instance" "tiny_test" {
#   ami                  = "ami-0a24e6e101933d294"
#   instance_type        = "m7g.medium"
#   iam_instance_profile = "ssm"
#   user_data            = <<EOF
# #!/bin/bash
# sudo apt-get update -y &&
# sudo apt-get install -y nginx zsh
# EOF
#   subnet_id            = data.aws_subnets.sa-lab-private.ids[0]
#   vpc_security_group_ids = [
#     aws_security_group.allow_ssh.id,
#     aws_security_group.web.id,
#   ]
#   associate_public_ip_address = false
#   key_name                    = "riley"
#   tags = {
#     Name     = "tiny_test"
#     Schedule = "us-work-hours"
#   }
# }

# resource "aws_instance" "ssh_target" {
#   ami                  = "ami-0ecb0bb5d6b19457a"
#   instance_type        = "t2.micro"
#   iam_instance_profile = "ssm"
#   #   user_data                   = <<EOF
#   # #!/bin/bash
#   # sudo apt-get update -y &&
#   # sudo apt-get install -y nginx zsh
#   # EOF
#   subnet_id                   = data.aws_subnets.sa-lab-private.ids[0]
#   vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
#   associate_public_ip_address = false
#   key_name                    = "riley"
#   tags = {
#     Name     = "ssh_target"
#     Schedule = "us-work-hours"
#   }
# }