# vpc
resource "aws_vpc" "crm_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "crm_vpc"
  }
}

#web subnet
resource "aws_subnet" "crm-web-sn" {
  vpc_id     = aws_vpc.crm_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "crm-web-subnet"
  }
}

#api subnet
resource "aws_subnet" "crm-api-sn" {
  vpc_id     = aws_vpc.crm_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "crm-api-subnet"
  }
}

# Database subnet
resource "aws_subnet" "crm-db-sn" {
  vpc_id     = aws_vpc.crm_vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "crm-database-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "crm-igw" {
  vpc_id = aws_vpc.crm_vpc.id

  tags = {
    Name = "crm-internet-gateway"
  }
}

# Public Route table
resource "aws_route_table" "crm-pub-rt" {
  vpc_id = aws_vpc.crm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.crm-igw.id
  }

  tags = {
    Name = "crm-pubic-route"
  }
}

# Private route table
resource "aws_route_table" "crm-pvt-rt" {
  vpc_id = aws_vpc.crm_vpc.id

tags = {
    Name = "crm-private-route"
  }
}
# crm Public association subnet
resource "aws_route_table_association" "crm-web-asc" {
  subnet_id      = aws_subnet.crm-web-sn.id
  route_table_id = aws_route_table.crm-pub-rt.id
}

#crm public association
resource "aws_route_table_association" "crm-api-asc" {
  subnet_id      = aws_subnet.crm-api-sn.id
  route_table_id = aws_route_table.crm-pub-rt.id
}

# crm private association
resource "aws_route_table_association" "crm-db-asc" {
  subnet_id      = aws_subnet.crm-db-sn.id
  route_table_id = aws_route_table.crm-pvt-rt.id
}

# crm web nacl

resource "aws_network_acl" "crm-web-nacl" {
  vpc_id = aws_vpc.crm_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 1000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "crm-web-nacl"
  }
}

# crm api nacl

resource "aws_network_acl" "crm-api-nacl" {
  vpc_id = aws_vpc.crm_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 1000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "crm-api-nacl"
  }
}

#crm db nacl

resource "aws_network_acl" "crm-db-nacl" {
  vpc_id = aws_vpc.crm_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 1000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "crm-api-nacl"
  }
}

#crm web nacl association
resource "aws_network_acl_association" "crm-web-nacl-asc" {
  network_acl_id = aws_network_acl.crm-web-nacl.id
  subnet_id      = aws_subnet.crm-web-sn.id
}

#crm api nacl association
resource "aws_network_acl_association" "crm-api-nacl-asc" {
  network_acl_id = aws_network_acl.crm-api-nacl.id
  subnet_id      = aws_subnet.crm-api-sn.id
}

#crm db nacl association
resource "aws_network_acl_association" "crm-db-nacl-asc" {
  network_acl_id = aws_network_acl.crm-db-nacl.id
  subnet_id      = aws_subnet.crm-db-sn.id
}