data "aws_availability_zones" "available-zone" {
    state = "available"
}

resource "aws_vpc" "eks-test-clueter-vpc" {
    cidr_block = "10.25.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "kubernetes.io/cluster/test-cluster"
        "kubernetes.io/cluster/test-cluster" = "shared"
    }
}

resource "aws_subnet" "eks-test-cluster-subnet" {
    count = length(data.aws_availability_zones.available-zone.zone_ids)

    availability_zone = data.aws_availability_zones.available-zone.names[count.index]
    cidr_block        = cidrsubnet(aws_vpc.eks-test-clueter-vpc.cidr_block, 8, count.index)
    vpc_id            = aws_vpc.eks-test-clueter-vpc.id
    map_public_ip_on_launch = true

    tags = {
        Name = "kubernetes.io/cluster/test-cluster"
        "kubernetes.io/cluster/test-cluster" = "shared"
        "kubernetes.io/role/elb" = 1
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.eks-test-clueter-vpc.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.eks-test-clueter-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
      Name = "eks-test-routetalbe"
  }
}

resource "aws_route_table_association" "internet_access" {
  count = length(data.aws_availability_zones.available-zone.zone_ids)
  subnet_id      = aws_subnet.eks-test-cluster-subnet[count.index].id
  route_table_id = aws_route_table.main.id
}
