data "aws_availability_zones" "available-zone" {
    state = "available"
}

resource "aws_vpc" "eks-test-clueter-vpc" {
    cidr_block = "10.25.0.0/16"
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
    tags = {
        Name = "kubernetes.io/cluster/test-cluster"
        "kubernetes.io/cluster/test-cluster" = "shared"
    }
}