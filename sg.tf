# -----------------------------
# EKS Cluster Security Group
# -----------------------------
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS control plane"
  vpc_id      = data.aws_vpc.default.id

  # Allow worker nodes to communicate with control plane
  ingress {
    description     = "Allow nodes to communicate with cluster API"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_node_sg.id]
  }

  # Allow public access to API server (optional)
  ingress {
    description = "Public API access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg"
  }
}

# -----------------------------
# EKS Worker Node Security Group
# -----------------------------
resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = data.aws_vpc.default.id

  # Allow worker nodes to communicate with cluster control plane
  ingress {
    description     = "Node to cluster communication"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }

  # Node-to-node communication for pods (TCP)
  ingress {
    description = "Pod-to-pod communication TCP"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  # Node-to-node communication for pods (UDP)
  ingress {
    description = "Pod-to-pod communication UDP"
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    self        = true
  }

  # Kubelet API access from control plane
  ingress {
    description     = "Allow control plane to access kubelet"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }

  # SSH access for debugging 
  ingress {
    description = "SSH access to nodes \"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSM Agent access (port 443 to internet)
  egress {
    description = "Allow nodes to connect to SSM endpoints"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow nodes to pull images from ECR/Internet
  egress {
    description = "Allow nodes to pull container images"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-node-sg"
  }
}
