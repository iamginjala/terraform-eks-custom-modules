output "sample_vpc_id" {
    value = aws_vpc.sample_vpc.id 
    description = "vpc id of the network"
}

output "sample_private_subnet" {
    value = values(aws_subnet.sample_private_subnet)[*].id
    description = "private subnets id"
  
}

output "sample_public_subnet" {
  value = values(aws_subnet.sample_public_subnet)[*].id
  description = "public subnets id"
}