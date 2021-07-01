resource "aws_security_group" "this" {
  name_prefix = var.name
  description = "Attached to all Bitbucket instances"
  vpc_id      = var.vpc_id

  tags = merge(var.tags,
    { "Name" : var.name }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_all" {
  count             = var.asg_allow_outbound_egress ? 1 : 0
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  description       = "Allow outbound egress"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.this.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "allow_inbound_http_from_lb" {
  description              = "Allow HTTPS traffic from the load balancer"
  from_port                = 7990
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = try(aws_security_group.alb_https[0].id, aws_security_group.elb[0].id)
  to_port                  = 7990
  type                     = "ingress"
}

resource "aws_security_group_rule" "allow_inbound_http_from_lb_ssh" {
  count = var.create_alb ? 0 : 1

  description              = "Allow SSH traffic from the load balancer"
  from_port                = 7999
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = aws_security_group.elb[0].id
  to_port                  = 7999
  type                     = "ingress"
}

resource "aws_security_group_rule" "allow_inbound_from_lb_ssh" {
  count = var.create_alb ? 1 : 0

  cidr_blocks       = var.alb_allowed_ssh_cidr_blocks
  description       = "Allow SSH traffic - NLBs do not support SGs"
  from_port         = 7999
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  to_port           = 7999
  type              = "ingress"
}
