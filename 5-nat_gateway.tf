resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  aallocation_id = aws_eip.nat_eip.id
  susubnet_id = aws_subnet.private.id

  tags = {
    "Name" = "nat_gateway"
  }

  depends_on= [aws_internet_gateway.igw ]  
}

