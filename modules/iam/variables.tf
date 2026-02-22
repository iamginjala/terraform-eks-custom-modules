variable "cluster_name" {
  type = string
  description = "cluster name for the iam role"
}


variable "name_prefix" {
  description = "prefix for the resources"
  type = string
}

variable "tags" {
  description = "tags for the entire project"
  type = map(string)
  default = {
    "tool" = "eks_cluster"

  }
}
