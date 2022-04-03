resource "aws_autoscaling_group" "dmz" {
    name = "dmz-asg"
    min_size = 1
    max_size = 1
    desired_capacity = 1
    health_check_grace_period = 300
    vpc_zone_identifier = aws_subnet.public[*].id

    launch_template {
        id = aws_launch_template.dmz.id
        version = "$Latest"
    }
}

resource "aws_eip" "dmz" {
    vpc = true
    tags = {
        Name = "DMZ-IP"
    }
}

resource "aws_key_pair" "key" {
    key_name = "dan-key"
    public_key = var.public_ssh_key
}

resource "aws_launch_template" "dmz" {
    name_prefix = "dmz"
    image_id = var.nat_ami
    instance_type = var.nat_instance
    key_name = aws_key_pair.key.key_name
    iam_instance_profile {
        name = aws_iam_instance_profile.dmz_profile.name
    }
    network_interfaces {
        associate_public_ip_address = true
        security_groups = [
            aws_security_group.dmz.id
        ]
    }
    user_data = base64encode(<<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install awscli -y
aws ec2 disassociate-address \
    --association-id ${aws_eip.dmz.association_id} \
    --public-ip ${aws_eip.dmz.public_ip} \
    --region ${var.region}
aws ec2 associate-address \
    --instance-id "$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)" \
    --allocation-id ${aws_eip.dmz.allocation_id} --region ${var.region}
EOF
    )
}

resource "aws_security_group" "dmz" {
    name = "nat-egress-allowed"
    description = "Allows egress through the DMZ NAT gateway"
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "nat-egress-allowed"
    }
}

resource "aws_security_group_rule" "vpc_ingress" {
    type = "ingress"
    description = "Allow ingress from VPC"
    from_port = 0
    to_port = 65535
    protocol = -1
    cidr_blocks = [aws_vpc.vpc.cidr_block]
    security_group_id = aws_security_group.dmz.id
}
resource "aws_security_group_rule" "ssh_ingress" {
    type = "ingress"
    description = "Allow SSH ingress"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["80.220.141.242/32"]
    security_group_id = aws_security_group.dmz.id
}
resource "aws_security_group_rule" "egress_http" {
    type = "egress"
    description = "Allow http egress"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.dmz.id
}
resource "aws_security_group_rule" "egress_https" {
    type = "egress"
    description = "Allow https egress"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.dmz.id
}

resource "aws_iam_role" "dmz_role" {
    name = "dmz-role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

    inline_policy {
        name = "ec2_access"

        policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
            Action   = ["ec2:*"]
            Effect   = "Allow"
            Resource = "*"
            },
        ]
        })
    }
}

resource "aws_iam_instance_profile" "dmz_profile" {
    name = "dmz_profile"
    role = aws_iam_role.dmz_role.name
}