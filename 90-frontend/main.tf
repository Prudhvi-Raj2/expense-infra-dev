resource "aws_instance" "frontend" {
    ami                    = data.aws_ami.joindevops.id
    vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
    instance_type          = "t3.micro"
    subnet_id              = local.public_subnets_id
    tags = merge(
        var.common_tags,
        {
        Name = local.resource_name
        }
    )
    # user_data = file("frontend.sh")
}

resource "null_resource" "frontend" {
    triggers = {
        instance_id = aws_instance.frontend.id
    }

connection {
    host     = aws_instance.frontend.public_ip
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
}
provisioner "file" {
    source      = "frontend.sh"
    destination = "/tmp/frontend.sh"
}   
provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/frontend.sh",
        "sudo sh /tmp/frontend.sh ${var.environment}"
    ]
}
}

resource "aws_ec2_instance_state" "frontend" {
    instance_id = aws_instance.frontend.id
    state       = "stopped"
    depends_on  = [null_resource.frontend]
}
resource "aws_ami_from_instance" "frontend" {
    name               = local.resource_name
    source_instance_id = aws_instance.frontend.id
    depends_on         = [aws_ec2_instance_state.frontend]
}
resource "null_resource" "frontend_delete" {
    triggers = {
        instance_id = aws_instance.frontend.id
    }
    depends_on = [aws_ami_from_instance.frontend]
    provisioner "local-exec" {
        command = "aws ec2 terminate-instances --instance-ids ${aws_instance.frontend.id} --region us-east-1"
    }
    
}

resource "aws_lb_target_group" "frontend" {
  name     = local.resource_name
  port     = 80
  protocol = "HTTPS"
  vpc_id   = local.vpc_id
  health_check {
    path                = "/"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
  tags = var.common_tags
  
}

resource "aws_launch_template" "frontend" {
  name_prefix   = local.resource_name
  image_id      = aws_ami_from_instance.frontend.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"

  vpc_security_group_ids = [local.frontend_sg_id]
  user_data              = base64encode("#!/bin/bash\necho Hello World > /tmp/hello.txt")

  tag_specifications {
    resource_type = "instance"
    }
    tags ={
        Name = local.resource_name
        }
}

resource "aws_autoscaling_group" "frontend" {
  name                      = local.resource_name
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 180
  health_check_type         = "ELB"
  desired_capacity          = 1
  vpc_zone_identifier       = local.public_subnets_ids
  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.frontend.arn]
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      }
    triggers = ["launch_template"]
  }
  tag {
    key                 = "Name"
    value               = local.resource_name
    propagate_at_launch = true
  }
  timeouts {
    delete = "5m"
  }
  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = false
  }
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = false
  } 
}

resource "aws_autoscaling_policy" "frontend" {
  name                   = "${local.resource_name}-frontend"
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value       = 70.0
  }
  
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = data.aws_ssm_parameter.web_alb_listener_arn.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["${var.project_name}-${var.environment}.${var.domain_name}"]
    }
  }

  depends_on = [aws_autoscaling_group.frontend]

}

