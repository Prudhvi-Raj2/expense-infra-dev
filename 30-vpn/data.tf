data "aws_ami" "openvpn" {
    most_recent = true
    owners = [ "679593333241" ]
  
    filter {
        name = "name"
        values = [ "OpenVPN Access Server Community Image-fe8020*" ]
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

data "aws_ssm_parameter" "vpn_sg_id" {
   name = "/${var.project_name}/${var.environment}/vpn_sg_id"
  
}

data "aws_ssm_parameter" "public_subnets_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnets_ids"
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