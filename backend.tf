terraform {
  backend "s3" {
    bucket = "deom-for-tfstate-files-0128"
    encrypt = true
    region = "us-east-2"
    key = "dev/eks-cluster/terraform.tfstate"
    use_lockfile = true
  }
}