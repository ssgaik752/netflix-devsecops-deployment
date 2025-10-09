module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                   = "eks-cluster"
  kubernetes_version                = "1.33"
  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }
  endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  # control_plane_subnet_ids = module.vpc.intra_subnets

  # # EKS Managed Node Group(s)
  # eks_managed_node_group_defaults = {
  #   ami_type       = "AL2_x86_64"
  #   instance_types = ["m5.large"]

  #   attach_cluster_primary_security_group = true
  # }

  eks_managed_node_groups = {
    amc-cluster-wg = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"

      tags = {
        ExtraTag = "helloworld"
      }
    }
  }

  tags = local.tags
}
