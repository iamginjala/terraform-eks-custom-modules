output "cluster_name" {
  value = aws_eks_cluster.sample_eks_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.sample_eks_cluster.endpoint
}
output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.sample_eks_cluster.certificate_authority[0].data
}
output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.sample_eks_cluster.identity[0].oidc[0].issuer
}