resource "aws_security_group" "this" {
  name_prefix = var.name
  description = "Attached to all Bitbucket instances"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    map(
      "Name", "${var.name}"
    )
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
  source_security_group_id = aws_security_group.elb.id
  to_port                  = 7990
  type                     = "ingress"
}

resource "aws_security_group_rule" "allow_inbound_http_from_lb_ssh" {
  description              = "Allow SSH traffic from the load balancer"
  from_port                = 7999
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = aws_security_group.elb.id
  to_port                  = 7999
  type                     = "ingress"
}
