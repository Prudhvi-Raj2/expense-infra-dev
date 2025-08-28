data "aws_ami" "joindevops" {
    most_recent = true
    owners = [ "973714476881" ]
  
    filter {
        name = "name"
        values = [ "RHEL-9-DevOps-Practice" ]
     }
    filter {
        name = "root-device-type"
        values = [ "ebs" ]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

data "aws_ssm_parameter" "backend_sg_id" {
   name = "/${var.project_name}/${var.environment}/backend_sg_id"
  
}

data "aws_ssm_parameter" "private_subnets_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnets_ids"
}

data "aws_ssm_parameter" "vpc_id"{
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "app_alb_listener_arn" {
  name = "/${var.project_name}/${var.environment}/app_alb_listener_arn"  
}









/* data "aws_vpc" "default" {
    default = true
  
}

output "ami_id" {
    value = data.aws_ami.joindevops.id
  
}

output "default_vpc_id"{
    value = data.aws_vpc.default.id
} */