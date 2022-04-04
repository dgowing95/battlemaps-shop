resource "aws_security_group" "nat_egress" {
    name = "nat-egress-allowed"
    description = "Allows egress through the DMZ NAT gateway"
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "nat-egress-allowed"
    }
}

resource "aws_security_group_rule" "http_egress" {
    type = "egress"
    description = "Allow http egress"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.nat_egress.id
}
resource "aws_security_group_rule" "https_egress" {
    type = "egress"
    description = "Allow https egress"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.nat_egress.id
}