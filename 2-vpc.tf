resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidrblock
  tags = {
    "Name" = "vpc_${random_pet.pet.id}_${terraform.workspace}"
  }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.0.0/28"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.1.0/28"
  
  tags = {
    "Name" = "private_subnet"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "association" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.route_table.id
}