resource "aws_security_group" "elb" {
  name_prefix = var.name
  description = "Bitbucket Inbound ELB"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    var.elb_additional_sg_tags,
    { "Name" : "${var.name}" }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elb_egress" {
  description              = "Allow traffic from the ELB to the instances"
  from_port                = 7990
  protocol                 = "tcp"
  security_group_id        = aws_security_group.elb.id
  source_security_group_id = aws_security_group.this.id
  to_port                  = 7990
  type                     = "egress"
}

resource "aws_security_group_rule" "elb_egress_ssh" {
  description              = "Allow SSH traffic from the ELB to the instances"
  from_port                = 7999
  protocol                 = "tcp"
  security_group_id        = aws_security_group.elb.id
  source_security_group_id = aws_security_group.this.id
  to_port                  = 7999
  type                     = "egress"
}

resource "aws_security_group_rule" "elb_ingress" {
  count = length(var.elb_allowed_cidr_blocks) > 0 ? 1 : 0

  cidr_blocks       = var.elb_allowed_cidr_blocks #tfsec:ignore:AWS006
  description       = "Allow HTTPS traffic from the allowed ranges"
  from_port         = var.elb_port
  protocol          = "tcp"
  security_group_id = aws_security_group.elb.id
  to_port           = var.elb_port
  type              = "ingress"
}

resource "aws_security_group_rule" "elb_ingress_ssh" {
  count = length(var.elb_allowed_cidr_blocks) > 0 ? 1 : 0

  cidr_blocks       = var.elb_allowed_cidr_blocks #tfsec:ignore:AWS006
  description       = "Allow SSH traffic from the allowed ranges"
  from_port         = var.elb_ssh_port
  protocol          = "tcp"
  security_group_id = aws_security_group.elb.id
  to_port           = var.elb_ssh_port
  type              = "ingress"
}

resource "aws_elb" "this" {
  name_prefix     = substr(var.name, 0, 6)
  internal        = var.elb_internal
  security_groups = [aws_security_group.elb.id]
  subnets         = var.elb_subnets
  tags            = var.tags

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:7990/status"
    interval            = 30
  }

  listener {
    instance_port      = 7990
    instance_protocol  = "http"
    lb_port            = var.elb_port
    lb_protocol        = "https"
    ssl_certificate_id = var.elb_certificate
  }

  listener {
    instance_port     = 7999
    instance_protocol = "tcp"
    lb_port           = var.elb_ssh_port
    lb_protocol       = "tcp"
  }
}
