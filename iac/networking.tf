resource "aws_vpc" "vpc" {
  cidr_block = "30.0.0.0/16"
  tags = {
      Name = "iac_vpc"
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
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, length(data.aws_availability_zones.azs.names) + count.index)

  tags = {
    Name = "pub_subnet_${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "iac_igw"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

}

resource "aws_route_table_association" "pub_assoc" {
  count = length(aws_subnet.public)

  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_network_interface.dmz_eni.id
  }

}

resource "aws_route_table_association" "priv_assoc" {
  count = length(aws_subnet.private)

  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}