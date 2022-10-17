//using module to create the vpc, subnet, RT, natgw, RT association to subnets

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs             = [var.zone1, var.zone2, var.zone3]
  private_subnets = [var.priv_cidr1, var.priv_cidr2, var.priv_cidr3]
  public_subnets  = [var.pub_cidr1, var.pub_cidr2, var.pub_cidr3]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}