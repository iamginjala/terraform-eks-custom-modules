resource "aws_iam_role" "sample_eks_cluster_role" {
  name = "${var.name_prefix}-iam-cluster"
  assume_role_policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Effect": "Allow",
    "Principal": {
      "Service": "eks.amazonaws.com" 
    }
  }]
}
)
   tags = merge(var.tags,{
        name = "${var.name_prefix}-iam-cluster-role"
    })
}

resource "aws_iam_role" "sample_eks_worker_role" {
  name = "${var.name_prefix}-iam-worker"
  assume_role_policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com" 
    }
  }]
}
)
  tags = merge(var.tags,{
        name = "${var.name_prefix}-iam-worker-role"
    })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
    role = aws_iam_role.sample_eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "ec2_worker_policy" {
    role = aws_iam_role.sample_eks_worker_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "worker_policy" {
    role = aws_iam_role.sample_eks_worker_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "worker_cni_policy" {
    role = aws_iam_role.sample_eks_worker_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}