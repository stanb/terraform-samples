variable "sandbox_id" {}
variable "owner" {}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.sandbox_id}-vpc"
    Owner = "${var.owner}"
  }
}

resource "aws_subnet" "public-subnet1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "${var.sandbox_id}-public-subnet1"
    Owner = "${var.owner}"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "${var.sandbox_id}-public-subnet2"
    Owner = "${var.owner}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "${var.sandbox_id}-public-igw"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
  route = {
    gateway_id = "${aws_internet_gateway.igw.id}"
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "${var.sandbox_id}-rt"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table_association" "rta_subnet1" {
  route_table_id = "${aws_route_table.route_table.id}"
  subnet_id = "${aws_subnet.public-subnet1.id}"
}

resource "aws_route_table_association" "rta_subnet2" {
  route_table_id = "${aws_route_table.route_table.id}"
  subnet_id = "${aws_subnet.public-subnet2.id}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnet1_id" {
  value = "${aws_subnet.public-subnet1.id}"
}

output "public_subnet2_id" {
  value = "${aws_subnet.public-subnet2.id}"
}
