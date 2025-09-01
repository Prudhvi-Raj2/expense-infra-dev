module "alb" {
  source   = "terraform-aws-modules/alb/aws"
  internal = true

  #expense-dev-app-alb
  name                       = "${var.project_name}-${var.environment}-app-alb"
  vpc_id                     = data.aws_ssm_parameter.vpc_id.value
  subnets                    = local.private_subnet_ids
  create_security_group      = false
  security_groups            = [local.app_alb_sg_id]
  enable_deletion_protection = false
  #security_groups = [local.app_alb_sg]
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-app-alb"
    }
  )

}

resource "aws_lb_listener" "frontend" {
    load_balancer_arn = module.alb.arn
    port              = "443"
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = data.aws_acm_certificate.app_alb_cert.arn
    
    default_action {
        type             = "forward"
        target_group_arn = var.target_group_arn
    }
}