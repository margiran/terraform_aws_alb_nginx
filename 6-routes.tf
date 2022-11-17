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

resource "aws_route_table" "route_table_nat" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
  
}
resource "aws_route_table_association" "nat_association" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.route_table_nat.id
}
