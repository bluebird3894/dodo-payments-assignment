locals {
  name   = "dodo-eks"
  region = "ap-south-1"
  tags = {
    Project     = "Dodo-Payments-Assignment"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------------------------
# VPC Module: Network Foundation
# ------------------------------------------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true # Crucial for cost optimization (<$1/day NAT cost vs $3/day)
  enable_dns_hostnames = true

  # Tags required by AWS EKS and Kubernetes to discover subnets for LBs
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# EKS Module: Cluster & Managed Node Group
# ------------------------------------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.name
  cluster_version = "1.30"

  # Network configuration
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  # Grants the IAM user running Terraform admin rights to the cluster
  enable_cluster_creator_admin_permissions = true

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    dodo_nodes = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t3a.medium"]
      capacity_type  = "SPOT" # Leverages unused EC2 capacity at steep discounts

      labels = {
        role = "worker"
      }
    }
  }

  tags = local.tags
}