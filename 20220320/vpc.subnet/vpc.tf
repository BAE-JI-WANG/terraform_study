resource "aws_vpc" "main"{
	cidr_block = "10.0.0.0/16"
	
	tags = {
		Name = "vpc-test"
	}
}

resource "aws_subnet" "public_subnet" {
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.0.0/24"

	availability_zone = "ap-northeast-2a"

	tags = {
		Name = "terrform-public-subnet"
	}
}

resource "aws_subnet" "private_subnet" {
	vpc_id = aws_vpc.main.id
        cidr_block = "10.0.10.0/24"

        tags = {
                Name = "terrform-private-subnet"
        }
}

resource "aws_internet_gateway" "igw" {
	vpc_id = aws_vpc.main.id

	tags = {
		Name = "main"
	}
}

resource "aws_eip" "nat" {
	vpc = true

	lifecycle {
		create_before_destroy = true
	}
}
/*
resource "aws_nat_gateway" "nat_gateway" {
	allocation_id = aws_eip.nat.id

	subnet_id = aws_subnet.public_subnet.id

	tags = {
		Name = "NAT-GW-1"
	}
}
*/
resource "aws_route_table" "public" {
	vpc_id = aws_vpc.main.id

	/*route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}*/

	tags = {
		Name = "rt-public"
	}
}

resource "aws_route_table_association" "aws_route_table_association_public" {
	subnet_id = aws_subnet.public_subnet.id
	route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
        vpc_id = aws_vpc.main.id

        tags = {
                Name = "rt-private"
        }
}

resource "aws_route" "public_igw" {
	route_table_id = aws_route_table.public.id
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.igw.id
}

resource "aws_vpc_endpoint" "s3" {
	vpc_id = aws_vpc.main.id
	service_name = "com.amazonaws.ap-northeast-2.s3"
}

