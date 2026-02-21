# EKS Cluster - Terraform Custom Modules

## Architecture Overview

This project provisions a production-style Amazon EKS (Elastic Kubernetes Service) cluster on AWS using Terraform custom modules. The infrastructure is designed with security and modularity in mind.

## Infrastructure Components

```
                        +---------------------------+
                        |        AWS Cloud          |
                        |                           |
                        |   +-------------------+   |
                        |   |    VPC (10.0.0.0/16)  |
                        |   |                   |   |
                        |   |  Public Subnets    |   |
                        |   |  (3 AZs)           |   |
                        |   |  10.0.1.0/24       |   |
                        |   |  10.0.2.0/24       |   |
                        |   |  10.0.3.0/24       |   |
                        |   |       |            |   |
                        |   |   [IGW]  [NAT GW]  |   |
                        |   |       |     |      |   |
                        |   |  Private Subnets   |   |
                        |   |  (3 AZs)           |   |
                        |   |  10.0.4.0/24       |   |
                        |   |  10.0.5.0/24       |   |
                        |   |  10.0.6.0/24       |   |
                        |   |       |            |   |
                        |   |  [EKS Cluster]     |   |
                        |   |  +- General Nodes  |   |
                        |   |  |  (ON_DEMAND x2) |   |
                        |   |  +- Spot Nodes     |   |
                        |   |     (SPOT x2)      |   |
                        |   +-------------------+   |
                        |                           |
                        |   [IAM Roles] [KMS Key]   |
                        +---------------------------+
```

## Module Structure

```
EKS-cluster/
├── main.tf              # Root module - orchestrates all child modules
├── variables.tf         # Root-level input variables
├── provider.tf          # AWS provider configuration
├── backend.tf           # S3 remote state backend
└── modules/
    ├── vpc/             # Network infrastructure
    │   ├── variables.tf
    │   ├── main.tf
    │   └── output.tf
    ├── iam/             # IAM roles and policies
    │   ├── variables.tf
    │   ├── main.tf
    │   └── outputs.tf
    ├── kms/             # Encryption key management
    │   ├── variables.tf
    │   ├── main.tf
    │   └── outputs.tf
    └── eks/             # EKS cluster and node groups
        ├── variables.tf
        ├── main.tf
        └── outputs.tf
```

## Modules

### VPC Module
Creates the network foundation:
- VPC with DNS support enabled
- 3 public subnets (one per AZ) with auto-assign public IP
- 3 private subnets (one per AZ)
- Internet Gateway for public subnet internet access
- NAT Gateway for private subnet outbound traffic
- Route tables and associations for both subnet types

### IAM Module
Creates IAM roles with trust policies:
- **Cluster Role** - assumed by `eks.amazonaws.com` with `AmazonEKSClusterPolicy`
- **Node Role** - assumed by `ec2.amazonaws.com` with `AmazonEKSWorkerNodePolicy` and `AmazonEC2ContainerRegistryReadOnly`

### KMS Module
Creates a KMS encryption key:
- Automatic annual key rotation enabled
- Used to encrypt Kubernetes Secrets at rest in etcd

### EKS Module
Creates the Kubernetes cluster and worker nodes:
- EKS control plane spanning public and private subnets
- Secrets encryption via KMS `encryption_config`
- **General node group** - ON_DEMAND instances for stable workloads
- **Spot node group** - SPOT instances for cost-effective, fault-tolerant workloads
- Worker nodes deployed in private subnets for security

## Data Flow Between Modules

```
VPC ──── vpc_id, subnet_ids ────────┐
IAM ──── cluster_role_arn,          ├──► EKS Module
         node_role_arn ─────────────┤
KMS ──── key_arn ───────────────────┘
```

All inter-module communication flows through the **root module** - child modules do not reference each other directly.

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- An S3 bucket for remote state storage

## Usage

```bash
# Initialize Terraform and download providers
terraform init

# Preview the infrastructure changes
terraform plan

# Deploy the infrastructure
terraform apply

# Destroy all resources when done
terraform destroy
```

## Default Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| region | us-east-2 | AWS region |
| cidr_block | 10.0.0.0/16 | VPC CIDR block |
| cluster_name | demo-eks-cluster | EKS cluster name |
| kubernetes_version | 1.31 | Kubernetes version |
| instance_types | t3.medium | Worker node instance type |
| general desired/min/max | 2/1/3 | General node group scaling |
| spot desired/min/max | 2/1/3 | Spot node group scaling |

## Security Highlights

- Worker nodes in **private subnets** - no direct internet exposure
- KMS encryption for **Kubernetes Secrets at rest**
- IAM roles follow **least-privilege** with only required managed policies
- NAT Gateway allows private subnet outbound access without inbound exposure
- Remote state stored in S3 with **encryption enabled** and **state locking**


Scenario-based (What interviewers love)
 "Your EKS nodes are running but pods can't communicate. What do you check?"

Is the VPC CNI plugin running? (needs AmazonEKS_CNI_Policy)
Are security groups allowing traffic between nodes?
Are the nodes in private subnets with a working NAT Gateway?
Is the route table correctly pointing to the NAT GW?
Check kubectl get nodes — are nodes in Ready state?

"You ran terraform apply and it's been stuck for 30 minutes creating an EKS cluster. What do you do?"

EKS clusters normally take 10-15 minutes, node groups another 5-10. If stuck past 30 minutes: check AWS Console for cluster status, check CloudTrail for errors, verify IAM roles have correct policies, verify subnet configuration and route tables. Don't Ctrl+C — it can corrupt state. If truly stuck, let it timeout, then investigate.


CNI = Container Network Interface (not NCI). It's a standard that defines how networking is set up for containers.

In EKS, AWS provides its own CNI plugin called VPC CNI (aws-node). It runs as a DaemonSet on every worker node and does one critical job:

It assigns real VPC IP addresses to each pod.

Without it, pods have no IP address → no networking → no communication.

How I Connected the Error to the Missing Policy
The error message gives three clues:


container runtime network not ready
  → NetworkReady=false
    → Network plugin returns error: cni plugin not initialized
"cni plugin not initialized" — the VPC CNI plugin failed to start
The VPC CNI plugin needs to create and attach ENIs (Elastic Network Interfaces) to EC2 instances to give pods IP addresses
To manage ENIs, it needs IAM permissions → specifically AmazonEKS_CNI_Policy
So the chain is:


Missing AmazonEKS_CNI_Policy
  → VPC CNI plugin can't manage ENIs
    → CNI plugin fails to initialize
      → Nodes report NetworkReady=false
        → Pods can't get IP addresses
          → No communication
The 3 Required Policies for Worker Nodes
This is worth memorizing:

Policy	What it allows
AmazonEKSWorkerNodePolicy	Node can register with the EKS cluster
AmazonEC2ContainerRegistryReadOnly	Node can pull container images from ECR
AmazonEKS_CNI_Policy	VPC CNI plugin can manage ENIs for pod networking