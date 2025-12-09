output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

output "node_group_arn" {
  value = aws_eks_node_group.eks_nodes.arn
}

output "security_group_id" {
  value = aws_security_group.eks_sg.id
}
