variable "region" {
  default = "us-east-2"
  description = "region for the account"
  type = string
}
variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "pub_subnets" {
  type = map(string)
  description = "public sunets for the vpc"
  default = {
    "us-east-2a" = "10.0.1.0/24",
    "us-east-2b" = "10.0.2.0/24",
    "us-east-2c" = "10.0.3.0/24"
  }

}
variable "pri_subnets" {
  type = map(string)
  description = "public sunets for the vpc"
  default = {
    "us-east-2a" = "10.0.4.0/24",
    "us-east-2b" = "10.0.5.0/24",
    "us-east-2c" = "10.0.6.0/24"
  }

}
variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "demo-eks-cluster"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for all resource names"
  default     = "demo-eks"
}

variable "kms_description" {
  type        = string
  description = "Description for KMS encryption key"
  default     = "EKS cluster secrets encryption key"
}

variable "general_node_group_name" {
  type        = string
  description = "Name for the on-demand node group"
  default     = "general-nodes"
}

variable "spot_node_group_name" {
  type        = string
  description = "Name for the spot instance node group"
  default     = "spot-nodes"
}
variable "general_desired_size" {
  type = number
  description = "desired size of worker nodes"
  default = 2
}
variable "general_min_size" {
  type = number
  description = "min size of worker nodes"
  default = 1
}
variable "general_max_size" {
  type = number
  description = "max size of worker nodes"
  default = 3
}

variable "spot_desired_size" {
  type = number
  description = "desired size of worker nodes"
  default = 2
}
variable "spot_min_size" {
  type = number
  description = "min size of worker nodes"
  default = 1
}
variable "spot_max_size" {
  type = number
  description = "max size of worker nodes"
  default = 3
}
