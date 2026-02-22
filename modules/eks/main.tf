resource "aws_eks_cluster" "sample_eks_cluster" {
  name = var.cluster_name
  role_arn = var.cluster_role_arn
  version = var.kubernetes_version
  vpc_config {
    subnet_ids = concat(var.public_subnet_ids,var.private_subnet_ids)
  }
  encryption_config {
    provider {
      key_arn = var.key_identifier
    }
    resources = [ "secrets" ]
  }
}

resource "aws_eks_node_group" "general_eks_node_group" {
  cluster_name = aws_eks_cluster.sample_eks_cluster.name
  node_role_arn = var.node_role_arn
  subnet_ids = var.private_subnet_ids
  instance_types = var.instance_types
  capacity_type = "ON_DEMAND"
  node_group_name = var.general_node_group_name
  scaling_config {
    desired_size = var.general_desired_size
    min_size = var.general_min_size
    max_size = var.general_max_size
  }
}

resource "aws_eks_node_group" "spot_eks_node_group" {
  cluster_name = aws_eks_cluster.sample_eks_cluster.name
  node_role_arn = var.node_role_arn
  subnet_ids = var.private_subnet_ids
  instance_types = var.instance_types
  capacity_type = "SPOT"
  node_group_name = var.spot_node_group_name
  scaling_config {
    desired_size = var.spot_desired_size
    min_size = var.spot_min_size
    max_size = var.spot_max_size
  }
}