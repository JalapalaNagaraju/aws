resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = merge(map(
    "Name", "${var.project_prefix}-vpc"
  ), var.tags)
}

resource "aws_subnet" "subnet" {
  count                   = length(var.subnetPrefixes)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnetPrefixes[count.index]
  availability_zone       = var.availabilityZone[count.index]
  map_public_ip_on_launch = true
  tags = merge(map(
    "Name", "${var.subnetNames[count.index]}"
  ), var.tags)
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(map(
    "Name", "${var.project_prefix}-igw"
  ), var.tags)
}

resource "aws_route_table" "routeTable" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(map(
    "Name", "${var.project_prefix}-pubRouteTable"
  ), var.tags)
}

resource "aws_route_table_association" "routeTableAssociation" {
  count          = length(aws_subnet.subnet.*.id)
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.routeTable.id
}

resource "aws_security_group" "internal-securitygroup" {
  name        = "internal-app-sg"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.vpc.id
  tags = merge(map(
    "Name", "${var.project_prefix}-internalSG"
  ), var.tags)
}

resource "aws_security_group" "elb-sgz" {
  name        = "elb-sgz"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.vpc.id
  tags = merge(map(
    "Name", "${var.project_prefix}-elbSG"
  ), var.tags)
}


resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(map(
    "Name", "${var.project_prefix}-nacl"
  ), var.tags)
}

resource "aws_network_acl_rule" "naclRule" {
  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 200
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "naclRuleEgress" {
  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}