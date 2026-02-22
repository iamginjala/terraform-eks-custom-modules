variable "cidr_block" {
  description = "cidr block for the entire vpc"
  type = string
}

variable "pub_subnet" {
  description = "public subnet for the vpc"
  type = map(string)
}

variable "pri_subnet" {
  description = "private subnet for the vpc"
  type = map(string)
}

variable "tags" {
  description = "tags for the entire project"
  type = map(string)
  default = {
    "tool" = "eks_cluster"

  }
}
variable "name_prefix" {
  description = "prefix for the resources"
  type = string
}
