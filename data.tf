data "aws_route53_zone" "route53" {
  name         = "subhasri.aws.crlabs.cloud"
  private_zone = false  
}


data "aws_availability_zones" "available" {
  state = "available" 
}