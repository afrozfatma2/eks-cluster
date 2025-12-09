variable "region" {
  default = "ap-south-1"
}

variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "node_count" {
  default = 2
}

variable "node_instance_type" {
  default = "t3.small"
}
