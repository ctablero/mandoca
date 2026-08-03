resource "aws_internet_gateway" "cluster_internet_gateway" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-cluster-internet-gateway"
  }
}

resource "aws_subnet" "cluster_subnets" {
  for_each = var.subnets_specs
  vpc_id            = var.vpc_id
  map_public_ip_on_launch = true
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.avail_zone

  tags = {
    Name = "${var.env_prefix}-cluster-subnet-${each.value.avail_zone}"
  }
}

resource "aws_route_table" "cluster_route_table" {
  
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cluster_internet_gateway.id
  }

  tags = {
    Name = "${var.env_prefix}-cluster-route-table"
  }
}

resource "aws_route_table_association" "route_table_association_subnets" {
  for_each = aws_subnet.cluster_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.cluster_route_table.id
}
