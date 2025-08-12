data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project_name}/${var.environment}/mysql_sg_id"
}

data "aws_ssm_parameter" "public_subnets_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnets_ids"
}

data "aws_ssm_parameter" "database_subnets_group_name" {
  name = "/${var.project_name}/${var.environment}/database_subnets_group_name"
}