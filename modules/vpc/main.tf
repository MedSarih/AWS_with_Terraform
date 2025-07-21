#create vpc
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = "${var.project_name}-vpc"
    }
}


#create internet gateway and attach it to vpc 
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

#use data source to fetch all availability zone in region 
data "aws_availability_zones" "available_zones" {}

#create public subnet pub_sub_1a
resource "aws_subnet" "pub_sub_1a" {
    vpc_id = aws_vpc.vpc.id   #links this subnet to the vpc
    cidr_block = var.pub_sub_1a_cidr #IP range for this subnet
    availability_zone = data.aws_availability_zones.available_zones.names[0] #create it in the first AZ
    map_public_ip_on_launch = true  # Auto-assign public IPs to any ec2 in the subnet

    tags = {
      Name = "pub_sub_1a"
      Type = "public"
    } 
}

#create public subnet pub_sub_2b
resource "aws_subnet" "pub_sub_2b" {
    vpc_id = aws_vpc.vpc.id   #links this subnet to the vpc
    cidr_block = var.pub_sub_2b_cidr #IP range for this subnet
    availability_zone = data.aws_availability_zones.available_zones.names[1] #create it in the second AZ
    map_public_ip_on_launch = true  # Auto-assign public IPs to any ec2 in the subnet

    tags = {
      Name = "pub_sub_2b"
      Type = "public"

    } 
}

#create a route table and add public route
resource "aws_route_table" "public_route_table" {
   vpc_id = aws_vpc.vpc.id

   route {
    cidr_block = "0.0.0.0/0"  # Match ANY external destination / send all non local traffic to the internet
    gateway_id = aws_internet_gateway.internet_gateway.id
   }

   tags = {
     Name = "Public-route"
   }
}


#associate public subnet in AZ1 to public route table
resource "aws_route_table_association" "pub_sub_1a_association" {
  subnet_id = aws_subnet.pub_sub_1a.id
  route_table_id = aws_route_table.public_route_table.id
}
#associate public subnet in AZ2 to public route table
resource "aws_route_table_association" "pub_sub_2b_association" {
  subnet_id = aws_subnet.pub_sub_2b.id
  route_table_id = aws_route_table.public_route_table.id
}

#create private app subnet pri_sub_3a
resource "aws_subnet" "pri_sub_3a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pri_sub_3a_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch  = false

  tags      = {
    Name    = "pri-sub-3a"
  }
  
}
#create private app subnet pri_sub_4b
resource "aws_subnet" "pri_sub_4b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pri_sub_4b_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch  = false

  tags      = {
    Name    = "pri-sub-4b"
  }
  
}

# create private data subnet pri-sub-5a
resource "aws_subnet" "pri_sub_5a" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_5a_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "pri-sub-5a"
  }
}

# create private data subnet pri-sub-6-b
resource "aws_subnet" "pri_sub_6b" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_6b_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false  #instances do NOT get a public IP unless you manually assign one.

  tags      = {
    Name    = "pri-sub-6b"
  }
}