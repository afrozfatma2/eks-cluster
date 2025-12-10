provider "aws" {
  region = "ap-south-1"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get the default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create EKS cluster with managed node groups
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "demo-eks-cluster"
  cluster_version = "1.29"
  vpc_id          = data.aws_vpc.default.id
  subnets         = data.aws_subnets.default.ids
  manage_aws_auth = true

  # Default settings for all managed node groups
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
    attach_cluster_primary_security_group = true
  }

  # Define specific managed node groups
  eks_managed_node_groups = {
    demo_node_group = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.medium"] 
      capacity_type  = "SPOT"        
    }
  }
}