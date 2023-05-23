module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name = "migration-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
  public_subnets  = [for i, v in local.availability_zones : cidrsubnet(local.public_subnet_cidr, 2, i)]
  private_subnets = [for i, v in local.availability_zones : cidrsubnet(local.private_subnet_cidr, 2, i)]
  database_subnets = [for i, v in local.availability_zones : cidrsubnet(local.database_subnet_cidr, 2, i)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

