module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.cidr_block
  name_prefix = var.name_prefix
  pub_subnet = var.pub_subnets
  pri_subnet = var.pri_subnets
}

module "iam" {
  source = "./modules/iam"
  cluster_name = var.cluster_name
  name_prefix = var.name_prefix
}

module "kms" {
  source = "./modules/kms"
  name_prefix = var.name_prefix
  description = var.kms_description
}

module "eks" {
  source = "./modules/eks"
  node_role_arn = module.iam.node_role_arn
  cluster_role_arn = module.iam.cluster_role_arn
  private_subnet_ids = module.vpc.sample_private_subnet
  public_subnet_ids = module.vpc.sample_public_subnet
  vpc_id = module.vpc.sample_vpc_id
  key_identifier = module.kms.key_identifier
  cluster_name = var.cluster_name
  spot_node_group_name = var.spot_node_group_name
  general_node_group_name = var.general_node_group_name
  general_desired_size = var.general_desired_size
  general_max_size = var.general_max_size
  general_min_size = var.general_min_size
  spot_desired_size = var.spot_desired_size
  spot_max_size = var.spot_max_size
  spot_min_size = var.spot_min_size
}
