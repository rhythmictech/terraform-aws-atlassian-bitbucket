resource "aws_security_group" "alb_https" {
  count = var.create_alb ? 1 : 0

  name_prefix = var.name
  description = "Bitbucket Inbound LB (HTTPS)"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    var.alb_additional_sg_tags,
    { "Name" : var.name }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "alb_https_egress" {
  count = var.create_alb ? 1 : 0

  description              = "Allow traffic from the LB to the instances"
  from_port                = 7990
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_https[0].id
  source_security_group_id = aws_security_group.this.id
  to_port                  = 7990
  type                     = "egress"
}


resource "aws_security_group_rule" "alb_https_ingress" {
  count = var.create_alb && length(var.alb_allowed_https_cidr_blocks) > 0 ? 1 : 0

  cidr_blocks       = var.alb_allowed_https_cidr_blocks #tfsec:ignore:AWS006
  description       = "Allow HTTPS traffic from the allowed ranges"
  from_port         = var.alb_https_port
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_https[0].id
  to_port           = var.alb_https_port
  type              = "ingress"
}

resource "aws_lb" "https" {
  count = var.create_alb ? 1 : 0

  name_prefix     = substr(var.name, 0, 6)
  internal        = var.alb_https_internal
  security_groups = [aws_security_group.alb_https[0].id]
  subnets         = var.alb_https_subnets
  tags            = var.tags

  dynamic "access_logs" {
    for_each = var.access_logs_enabled ? ["this"] : []

    content {
      bucket  = var.access_logs_bucket
      prefix  = var.access_logs_prefix
      enabled = var.access_logs_enabled
    }
  }
}


resource "aws_lb_listener" "https" {
  count = var.create_alb ? 1 : 0

  certificate_arn   = var.alb_certificate
  load_balancer_arn = aws_lb.https[0].arn
  port              = var.alb_https_port
  protocol          = "HTTPS"
  ssl_policy        = var.alb_ssl_policy
  tags              = var.tags

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.https[0].arn
  }
}

resource "aws_lb_target_group" "https" {
  count = var.create_alb ? 1 : 0

  name_prefix = substr(var.name, 0, 6)
  port        = 7990
  protocol    = "HTTP"
  tags        = var.tags
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/status"
    interval            = 30
  }
}

resource "aws_lb" "ssh" {
  count = var.create_alb ? 1 : 0

  name_prefix        = substr(var.name, 0, 6)
  internal           = var.alb_ssh_internal
  load_balancer_type = "network"
  subnets            = var.alb_ssh_subnets
  tags               = var.tags
}

resource "aws_lb_listener" "ssh" {
  count = var.create_alb ? 1 : 0

  load_balancer_arn = aws_lb.ssh[0].arn
  port              = var.alb_ssh_port
  protocol          = "TCP"
  tags              = var.tags

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ssh[0].arn
  }
}

resource "aws_lb_target_group" "ssh" {
  count = var.create_alb ? 1 : 0

  name_prefix = substr(var.name, 0, 6)
  port        = 7999
  protocol    = "TCP"
  tags        = var.tags
  vpc_id      = var.vpc_id
}
