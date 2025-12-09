provider "aws" {
  region = "ap-south-1"
}

# Single IAM Role for EKS Cluster and Nodes
resource "aws_iam_role" "eks_role" {
  name = "my-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["eks.amazonaws.com", "ec2.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach all required managed policies
resource "aws_iam_role_policy_attachment" "attach_all" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  ])
  role       = aws_iam_role.eks_role.name
  policy_arn = each.value
}
