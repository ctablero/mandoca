resource "aws_internet_gateway" "cluster_internet_gateway" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-cluster-internet-gateway"
  }
}

# Public networking, Required for the ELB internet facing and optional when No private subnets specs are provided.
resource "aws_subnet" "external_subnets" {
  for_each                = var.external_subnets_specs
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = true
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.avail_zone

  tags = {
    Name = "${var.env_prefix}-external-subnets-${each.value.avail_zone}"
  }
}

resource "aws_route_table" "external_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cluster_internet_gateway.id
  }

  tags = {
    Name = "${var.env_prefix}-cluster-route-table"
  }
}

resource "aws_route_table_association" "route_table_association_external_subnets" {
  for_each = aws_subnet.external_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.external_route_table.id
}

# Private networking, Required for the ASG instances when private subnets specs are provided.

## Regional NAT Gateway with auto mode
resource "aws_nat_gateway" "cluster_nat_gateway" {
  count  = length(var.internal_subnets_specs) > 0 ? 1 : 0
  vpc_id            = var.vpc_id
  availability_mode = "regional"

  depends_on = [aws_internet_gateway.cluster_internet_gateway]
}

resource "aws_subnet" "internal_subnets" {
  for_each                = var.internal_subnets_specs
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = false
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.avail_zone

  tags = {
    Name = "${var.env_prefix}-internal-subnets-${each.value.avail_zone}"
  }
}

resource "aws_route_table" "internal_route_table" {
  count  = length(var.internal_subnets_specs) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.cluster_nat_gateway[0].id
  }

  tags = {
    Name = "${var.env_prefix}-internal-route-table"
  }
}

resource "aws_route_table_association" "route_table_association_internal_subnets" {
  for_each = aws_subnet.internal_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.internal_route_table[0].id
}
