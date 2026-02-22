output "cluster_role_arn" {
  value = aws_iam_role.sample_eks_cluster_role.arn
}

output "node_role_arn" {
  value = aws_iam_role.sample_eks_worker_role.arn
}