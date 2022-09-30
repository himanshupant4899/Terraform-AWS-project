provider "kubernetes" {
  host                   = data.aws_eks_cluster.myapp-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.myapp-cluster.token
  load_config_file       = false
}

data "aws_eks_cluster" "myapp-cluster"{
  name = module.eks.cluster_ip
}

data "aws_eks_cluster_auth" "myapp-cluster"{
  name = module.eks.cluster_ip
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"
  cluster_name    = "myapp-eks-cluster"
  cluster_version = "1.22"

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = "dev"
    application   = "myapp"
  }

  self_managed_node_groups = {
    group-one = {
      name = "worker-group-1"
      desired_size = 2
      instance_type = "t2.small"
    }
    group-two = {
      name = "worker-group-2"
      desired_size = 3
      instance_type = "t2.micro"
    }
  }
}