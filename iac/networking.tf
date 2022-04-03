resource "aws_vpc" "vpc" {
  cidr_block = "30.0.0.0/16"
  tags = {
      Name = "Battlemap VPC"
  }
}

data "aws_availability_zones" "azs" {
  all_availability_zones = true
}

resource "aws_subnet" "private" {
  count = length(data.aws_availability_zones.azs.names)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "priv_subnet_${count.index}"
  }
}

resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.azs.names)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, (length(data.aws_availability_zones.azs.names) - 1) + count.index)

  tags = {
    Name = "pub_subnet_${count.index}"
  }
}