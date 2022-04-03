resource "aws_autoscaling_group" "dmz" {
    name = "dmz-asg"
    min_size = 1
    max_size = 1
    desired_capacity = 1
    health_check_grace_period = 300
    vpc_zone_identifier = [aws_subnet.public.*.id]

    launch_template {
        id = aws_launch_template.dmz.id
        version = "$Latest"
    }
}

resource "aws_launch_template" "dmz" {
    name_prefix = "dmz"
    image_id = var.nat_ami
    instance_type = var.nat_instance
    key_name = aws_key_pair.key.key_name
}

resource "aws_key_pair" "key" {
    key_name = "dan-key"
    public_key = var.public_ssh_key
}