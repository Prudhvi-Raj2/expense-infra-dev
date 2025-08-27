locals {
  private_subnets_id = split(",", data.aws_ssm_parameter.private_subnets_ids.value)[0]
}