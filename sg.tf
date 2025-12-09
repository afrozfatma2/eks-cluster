# Single Security Group for EKS Cluster and Nodes
resource "aws_security_group" "eks_sg" {
  name        = "eks-sg"
  description = "Security group for EKS cluster and worker nodes"
  vpc_id      = data.aws_vpc.default.id

  # Allow HTTPS traffic to EKS API server (public access)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow node-to-node pod communication (TCP)
  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  # Allow node-to-node pod communication (UDP)
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    self      = true
  }

  # Kubelet API access
  ingress {
    from_port = 10250
    to_port   = 10250
    protocol  = "tcp"
    self      = true
  }

  # Optional SSH access to nodes
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic for Internet, SSM, ECR
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-sg"
  }
}
