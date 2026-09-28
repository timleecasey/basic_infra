# aws_region's `region` attribute (6.x; `name` is deprecated there).
terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

data "aws_region" "current" {
}

# A gateway endpoint adds a route to the service's prefix list on each route
# table: private subnets reach the service with no NAT or internet gateway.
resource "aws_vpc_endpoint" "this" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.${var.service}"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids
  policy            = var.policy
  tags              = local.tags
}
