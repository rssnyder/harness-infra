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

resource "aws_security_group" "proxy" {
  name        = "snyder-lab-proxy-allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.sa-lab.id

  ingress {
    description = "Open HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Open SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ephemeral ports
  ingress {
    description = "Ephemeral ports for RDS connect"
    from_port   = 1024
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
    Name = "snyder-lab-proxy-allow_http"
  }
}

resource "harness_autostopping_aws_proxy" "snyder_lab" {
  name               = "snyder-lab"
  cloud_connector_id = harness_platform_connector_awscc.rileyharnessccm.identifier
  host_name          = "192.168.0.1.nip.io"
  region             = data.aws_region.current.name
  vpc                = data.aws_vpc.sa-lab.id
  # subnet_id                         = data.aws_subnets.sa-lab-public.ids[0]
  security_groups                   = [aws_security_group.proxy.id]
  route53_hosted_zone_id            = null
  machine_type                      = "t3.micro"
  api_key                           = var.harness_platform_api_key
  keypair                           = "riley"
  allocate_static_ip                = true
  delete_cloud_resources_on_destroy = true
}

resource "aws_instance" "snyder-zero" {
  ami                  = "ami-008fe2fc65df48dac"
  instance_type        = "t3.xlarge"
  iam_instance_profile = "ssm"
  user_data            = <<EOF

#!/bin/bash
sudo apt-get update -y &&
sudo apt-get install -y zsh

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

curl -sLS https://get.k3sup.dev | sh
sudo install k3sup /usr/local/bin/

k3sup install --local --k3s-extra-args '--disable=traefik' --k3s-version v1.28.5+k3s1
export KUBECONFIG=/home/ubuntu/kubeconfig

kubectl apply -f https://raw.githubusercontent.com/rssnyder/isengard/master/k8s/bootstrap/nginx.yaml
kubectl apply -f https://raw.githubusercontent.com/rssnyder/isengard/master/k8s/test/whoami.yaml

EOF
  subnet_id            = data.aws_subnets.sa-lab-private.ids[0]
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.web.id,
  ]
  associate_public_ip_address = false
  key_name                    = "riley"
  tags = {
    Name     = "snyder-zero"
    Schedule = "none"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "harness_autostopping_rule_vm" "snyder-zero" {
  name               = aws_instance.snyder-zero.tags.Name
  cloud_connector_id = harness_platform_connector_awscc.rileyharnessccm.identifier
  idle_time_mins     = 5
  filter {
    vm_ids = [
      aws_instance.snyder-zero.id
    ]
    regions = [
      data.aws_region.current.name
    ]
  }
  tcp {
    proxy_id = harness_autostopping_aws_proxy.snyder_lab.id
    forward_rule {
      port       = 22
      connect_on = 50310
    }
  }
  custom_domains = [
    "35.84.250.59.nip.io"
  ]
}


resource "aws_instance" "snyder-one" {
  ami                  = "ami-008fe2fc65df48dac"
  instance_type        = "t3.micro"
  iam_instance_profile = "ssm"
  subnet_id            = data.aws_subnets.sa-lab-private.ids[0]
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.web.id,
  ]
  associate_public_ip_address = false
  key_name                    = "riley"
  tags = {
    Name             = "snyder-one"
    Schedule         = "none"
    snydergovernance = "target"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_instance" "snyder-two" {
  ami                  = "ami-008fe2fc65df48dac"
  instance_type        = "t3.micro"
  iam_instance_profile = "ssm"
  subnet_id            = data.aws_subnets.sa-lab-private.ids[0]
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.web.id,
  ]
  associate_public_ip_address = false
  key_name                    = "riley"
  tags = {
    Name             = "snyder-two"
    Schedule         = "none"
    snydergovernance = "target"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_instance" "snyder-three" {
  ami                  = "ami-008fe2fc65df48dac"
  instance_type        = "t3.micro"
  iam_instance_profile = "ssm"
  subnet_id            = data.aws_subnets.sa-lab-private.ids[0]
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.web.id,
  ]
  associate_public_ip_address = false
  key_name                    = "riley"
  tags = {
    Name             = "snyder-three"
    Schedule         = "none"
    snydergovernance = "target"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_instance" "snyder-four" {
  ami                  = "ami-008fe2fc65df48dac"
  instance_type        = "t3.micro"
  iam_instance_profile = "ssm"
  subnet_id            = data.aws_subnets.sa-lab-private.ids[0]
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.web.id,
  ]
  associate_public_ip_address = false
  key_name                    = "riley"

  user_data = <<EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get install stress

curl -L https://gist.githubusercontent.com/rssnyder/d830bce54f504407986daaa3585d1b18/raw/aee50637e3ed3bc68288b57782074444b089ec7c/stress1.service -o /etc/systemd/system/stress.service
sudo systemctl daemon-reload
sudo systemctl enable stress.service
sudo systemctl start stress.service

EOF

  tags = {
    Name             = "snyder-four"
    Schedule         = "none"
    snydergovernance = "target"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}