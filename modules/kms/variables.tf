variable "description" {
  type = string
  description = "label for the key"
}

variable "deletion_window_in_days" {
  type = number
  default = 7
  description = "can over ride this default value"
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
