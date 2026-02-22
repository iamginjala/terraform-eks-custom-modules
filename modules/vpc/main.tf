resource "aws_vpc" "sample_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = merge(
    var.tags,
    {
        name = "${var.name_prefix}-vpc"
    }
  )
}

resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample_vpc.id
  
  tags = merge(
    var.tags,
    {
        name = "${var.name_prefix}-igw"
    }
  )
}

resource "aws_eip" "sample_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "sample_natgw" {
  allocation_id = aws_eip.sample_eip.allocation_id
  subnet_id = values(aws_subnet.sample_public_subnet)[0].id
  depends_on = [ aws_internet_gateway.sample_igw ]

  
  tags = merge(
    var.tags,
    {
        name = "${var.name_prefix}-nat-gateway"
    }
  )

}

resource "aws_subnet" "sample_public_subnet" {
    for_each = var.pub_subnet
    vpc_id = aws_vpc.sample_vpc.id
    availability_zone = each.key
    cidr_block = each.value
    map_public_ip_on_launch = true
}

resource "aws_subnet" "sample_private_subnet" {
    for_each = var.pri_subnet
    vpc_id = aws_vpc.sample_vpc.id
    availability_zone = each.key
    cidr_block = each.value
}

resource "aws_route_table" "sample_public_rt" {
  vpc_id = aws_vpc.sample_vpc.id
  

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample_igw.id
  }
}

resource "aws_route_table" "sample_private_rt" {
  vpc_id = aws_vpc.sample_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sample_natgw.id
  }
}
resource "aws_route_table_association" "sample_public_rta" {
    for_each = aws_subnet.sample_public_subnet
    subnet_id = each.value.id
    route_table_id = aws_route_table.sample_public_rt.id

}

resource "aws_route_table_association" "sample_private_rta" {
    for_each = aws_subnet.sample_private_subnet
    subnet_id = each.value.id
    route_table_id = aws_route_table.sample_private_rt.id
}