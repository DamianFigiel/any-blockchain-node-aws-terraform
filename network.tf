##################################################################################
# NETWORKING
##################################################################################

module "app" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  cidr = var.vpc_cidr

  azs            = slice(data.aws_availability_zones.available.names, 0, var.subnets_count)
  public_subnets = [for subnet in range(var.subnets_count) : cidrsubnet(var.vpc_cidr, 8, subnet)]

  enable_nat_gateway      = false
  enable_vpn_gateway      = false
  map_public_ip_on_launch = true
  enable_dns_hostnames    = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}
