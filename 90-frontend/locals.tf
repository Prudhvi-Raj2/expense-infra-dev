locals {
  public_subnets_id  = split(",", data.aws_ssm_parameter.public_subnets_ids.value)[0]
  public_subnets_ids = split(",", data.aws_ssm_parameter.public_subnets_ids.value)
  resource_name       = "${var.project_name}-${var.environment}-frontend"
  vpc_id              = data.aws_ssm_parameter.vpc_id.value
  frontend_sg_id       = data.aws_ssm_parameter.frontend_sg_id.value
}