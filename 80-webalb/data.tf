data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnets_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnets_ids"
}

data "aws_ssm_parameter" "public_subnets_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnets_ids"
}

data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/web_alb_sg_id"
}

data "aws_ssm_parameter" "web_alb_certificate_arn" {
  name = "/${var.project_name}/${var.environment}/web_alb_certificate_arn"
}
