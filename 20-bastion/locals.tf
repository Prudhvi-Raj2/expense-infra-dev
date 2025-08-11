locals {
  public_subnets_ids = split(",", data.aws_ssm_parameter.public_subnets_ids.value)[0]
}