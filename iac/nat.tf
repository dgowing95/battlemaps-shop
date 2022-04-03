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
    network_interfaces {
        associate_public_ip_address = true
    }
    user_data = base64encode(<<EOF
"#!/bin/bash
sudo apt-get update
sudo apt-get install awscli -y
aws ec2 disassociate-address --public-ip ${aws_eip.dmz.public_ip} --region ${var.region}
aws ec2 associate-address \
    --instance-id "$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)" \
    --allocation-id ${aws_eip.dmz.allocation_id} --region eu-west-2"
EOF
    )
}