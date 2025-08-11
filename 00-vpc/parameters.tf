resource "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
  type = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnets_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnets_ids"
  type = "StringList"
  value = join(",",module.vpc.public_subnets_ids)
}
resource "aws_ssm_parameter" "private_subnets_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnets_ids"
  type = "StringList"
  value = join(",",module.vpc.private_subnets_ids)
}
resource "aws_ssm_parameter" "database_subnets_ids" {
  name = "/${var.project_name}/${var.environment}/database_subnets_ids"
  type = "StringList"
  value = join(",",module.vpc.database_subnets_ids)
}