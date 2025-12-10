variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "node_group_name" {
  default = "my-eks-nodes"
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "desired_capacity" {
  default = 2
}

variable "max_capacity" {
  default = 2
}

variable "min_capacity" {
  default = 2
}

variable "key_pair_name" {
  description = "EC2 key pair name for worker node SSH access"
  default     = "jenkins-server-key"  
}

variable "region" {
  description = "AWS region to deploy EKS cluster"
  default     = "ap-south-1"
}
