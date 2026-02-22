variable "vpc_id" {
 type = string
 description = "vpc_id for the eks cluster"  
}
variable "private_subnet_ids" {
  type = list(string)
  description = "private subnet_id for eks cluster"
}
variable "public_subnet_ids" {
  type = list(string)
  description = "public subnet_id for eks cluster"
}
variable "cluster_role_arn" {
  type = string
  description = "iam role for the control plane"
}
variable "node_role_arn" {
    type = string
    description = "iam role for the worker plane"
}
variable "cluster_name" {
  type = string
  description = "name of the eks cluster"
}
variable "general_node_group_name" {
  type = string
  description = "worker node group name for general"
}
variable "spot_node_group_name" {
  type = string
  description = "worker node group name for spot"
}
variable "kubernetes_version" {
  type = string
  default = "1.31"
  description = "kubernetes version"
}
variable "instance_types" {
  type = list(string)
  default = [ "t3.medium" ]
  description = "instance type of the worker node"
}


variable "general_desired_size" {
  type = number
  description = "desired instances for the application"
}

variable "general_min_size" {
  type = number
  description = "min instances for the application"
}

variable "general_max_size" {
    type = number
    description = "max instances for the application"
}

variable "spot_desired_size" {
  type = number
  description = "desired instances for the application"
}

variable "spot_min_size" {
  type = number
  description = "min instances for the application"
}

variable "spot_max_size" {
    type = number
    description = "max instances for the application"
}
variable "key_identifier" {
  type = string
  description = "kms key for encryption"
}