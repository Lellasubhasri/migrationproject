locals {
  availability_zones      = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)

  public_subnet_cidr      = cidrsubnet(var.vpc_cidr, 6, 4)
  private_subnet_cidr     = cidrsubnet(var.vpc_cidr, 7, 10)
  #application_subnet_cidr = cidrsubnet(local.private_subnet_cidr, 2, 0)
  database_subnet_cidr    = cidrsubnet(var.vpc_cidr, 7, 13)
  #staging_area_subnet_cidr = cidrsubnet(local.private_subnet_cidr,2, 2)

  
  private_random_ip = "192.168.0.235"

}