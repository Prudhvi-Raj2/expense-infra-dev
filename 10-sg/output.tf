output "mysql_sg_id" {
  value = aws_ssm_parameter.mysql_sg_id
  sensitive = true
}

output "backend_sg_id" {
  value = aws_ssm_parameter.backend_sg_id
  sensitive = true
}

output "frontend_sg_id"{
    value = aws_ssm_parameter.frontend_sg_id
    sensitive = true
}