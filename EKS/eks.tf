module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "~> 21.0"
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
  vpc_id                         = module.my-vpc.vpc_id
  subnet_ids                     = module.my-vpc.private_subnets
  tags = {
    environment = "development"
    application = "myapp"
  }
  eks_managed_node_groups = {
    dev = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.micro"]
    }
  }
}
