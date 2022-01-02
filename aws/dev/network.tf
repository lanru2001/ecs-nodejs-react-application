#VPC 
resource "aws_vpc" "app_vpc" {
  cidr_block              = var.vpc_cidr 
  enable_dns_support      = true
  enable_dns_hostnames    = true

  tags       = {
    Name     = "${local.environment_prefix}-dev-vpc"
  }
}

#Private subnets
resource "aws_subnet" "app_private_subnets" {
  count                   = var.create ? 2:0 
  vpc_id                  = aws_vpc.app_vpc.id
  availability_zone       = var.azs[count.index]  
  cidr_block              = var.private_subnets_cidr[count.index]   

  tags    = {
    Name  = "app-private-subnet-${count.index +1}"
  }
}

#Pubic subnets
resource "aws_subnet" "app_public_subnets" {
  count                     = var.create ? 2:0 
  vpc_id                   = aws_vpc.app_vpc.id
  availability_zone        = var.azs[count.index]    
  map_public_ip_on_launch  = true
  cidr_block               = var.public_subnets_cidr[count.index]   

  tags     = {
    Name   = "app-public-subnet-${count.index +1}"
  }
}

#IGW
resource "aws_internet_gateway" "app_igw" {
  vpc_id                    = aws_vpc.app_vpc.id

  tags     = {
    Name   = "${local.environment_prefix}-igw"
  }
}

#Route table for public subnet
resource "aws_route_table" "app_public_rtable" {
  count                     = var.create ? 2:0 
  vpc_id                    = aws_vpc.app_vpc.id

  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.app_igw.id
  }

  tags    = {
    Name  = "${local.environment_prefix }-prtable-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.app_igw]
}

#Route table for private subnet
resource "aws_route_table" "app_private_rtable" {
  count                     = var.create ? 2:0 
  vpc_id                    = aws_vpc.app_vpc.id

  #route {
  #  cidr_block              = "0.0.0.0/0"
  #  gateway_id              = aws_internet_gateway.app_igw.id
  #}

  tags    = {
    Name  = "${local.environment_prefix }-pvrtable-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.app_igw]
}

#Assign the route table to public subnets
resource "aws_route_table_association" "public-subnet-association" {
  count                     = var.create ? 2:0 
  subnet_id                 = aws_subnet.app_public_subnets[count.index].id
  route_table_id            = aws_route_table.app_public_rtable[count.index].id
}

#Assign the route table to private subnets
resource "aws_route_table_association" "private-subnet-association" {
  count                     = var.create ? 2:0 
  subnet_id                 = aws_subnet.app_private_subnets[count.index].id
  route_table_id            = aws_route_table.app_private_rtable[count.index].id
}

# Public route 
resource "aws_route" "public_route" {
  count           = var.create ? 2:0 
  route_table_id            = aws_route_table.app_public_rtable[count.index].id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                =  aws_internet_gateway.app_igw.id 
}

# private route 
resource "aws_route" "private_route" {
  count                     = var.create ? 2:0 
  route_table_id            = aws_route_table.app_private_rtable[count.index].id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.app_nat_gw.id
}

# EIP 
resource "aws_eip" "nat_eip" {
   vpc                       = true 
   #associate_with_private_ip = "10.0.0.5"
   depends_on                 = [aws_internet_gateway.app_igw]

}

# NAT Gateway
resource "aws_nat_gateway" "app_nat_gw" {
  allocation_id             = aws_eip.nat_eip.id
  subnet_id                 = aws_subnet.app_public_subnets[0].id
  depends_on                = [ aws_internet_gateway.app_igw ]

  tags = {
    Name =  "${local.module_prefix}-nat-gateway"
  }
}
