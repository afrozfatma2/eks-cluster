module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "22.0.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.30"
  subnets         = data.aws_subnets.default.ids
  vpc_id          = data.aws_vpc.default.id

  node_groups = {
    default_nodes = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 2

      instance_types = ["t3.medium"]

      ami_type = "AL2_x86_64"

      key_name = "" # Optional: add your key pair name here if you want SSH access
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
