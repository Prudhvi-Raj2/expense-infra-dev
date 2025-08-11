module "vpc" {
  #source = "../terraform-aws-vpc"
  source = "git::https://github.com/Prudhvi-Raj2/terraform-aws-vpc.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  vpc_cidr = var.vpc_cidr
  common_tags = var.common_tags
  vpc_tags = var.vpc_tags
  public_subnets_cidr = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  database_subnets_cidr = var.database_subnets_cidr
  is_peering_required = true
}

resource "aws_db_subnet_group" "expense" {
  name = "${var.project_name}-${var.environment}"
  subnet_ids = module.vpc.database_subnets_ids
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}"
    }
  )
}