data "template_cloudinit_config" "this" {

  part {
    filename = "text/x-shellscript"
    content  = local.configure_script
  }
}

data "aws_route53_zone" "zone" {
  count   = var.zone_id == null ? 0 : 1
  zone_id = var.zone_id
}

data "aws_secretsmanager_secret_version" "dbpassword" {
  secret_id = module.bitbucketdb.password_secretsmanager_arn
}

locals {
  #account_id    = data.aws_caller_identity.current.account_id
  domain_name   = try(data.aws_route53_zone.zone[0].name, var.domain_name)
  bitbucket_url = "${var.dns_prefix}.${local.domain_name}"
  db_name       = replace(local.short_name, "-", "")
  db_vpc_id     = var.db_vpc_id == null ? var.vpc_id : var.db_vpc_id
  short_name    = substr(var.name, 0, 32)

  configure_script = templatefile("${path.module}/templates/configure.sh.tpl",
    {
      admin_password = var.admin_password
      admin_email    = var.admin_email
      base_hostname  = local.bitbucket_url
      db_url         = "jdbc:postgresql://${module.bitbucketdb.instance_connection_info.endpoint}/bitbucketdb"
      db_username    = module.bitbucketdb.instance_connection_info.username
      db_password    = data.aws_secretsmanager_secret_version.dbpassword.secret_string
      license_key    = var.license_key
      site_name      = var.site_name
    }
  )

  db_allowed_security_groups = concat(
    [aws_security_group.this.id],
    var.bitbucket_additional_security_groups
  )
}

resource "aws_autoscaling_group" "this" {
  name_prefix               = var.name
  desired_capacity          = var.asg_desired_capacity
  health_check_grace_period = 600
  health_check_type         = "EC2"
  force_delete              = false
  launch_configuration      = aws_launch_configuration.this.name
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  target_group_arns         = [aws_lb_target_group.this.arn]
  wait_for_capacity_timeout = "15m"
  vpc_zone_identifier       = var.asg_subnets

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "this" {
  name_prefix                 = var.name
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.this.id
  image_id                    = var.ami_id
  instance_type               = var.asg_instance_type
  key_name                    = var.asg_key_name
  user_data_base64            = data.template_cloudinit_config.this.rendered

  security_groups = concat(
    var.asg_additional_security_groups,
    [aws_security_group.this.id]
  )

  root_block_device {
    encrypted   = true
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "bitbucketdb" {
  #source  = "rhythmictech/rds-postgres/aws"
  source = "/Users/cdaniluk/dev/tf/terraform-aws-rds-postgres"

  name                    = local.db_name
  allowed_cidr_blocks     = var.bitbucket_allowed_access_cidrs
  allowed_security_groups = local.db_allowed_security_groups
  # bitbucket DB backups aren't consistent and need to be managed externally, one backup is stored just for emergency use
  backup_retention_period      = 1
  engine_version               = var.db_engine_version
  identifier_prefix            = local.short_name
  instance_class               = var.db_instance_class
  monitoring_interval          = var.db_monitoring_interval
  monitoring_role_arn          = var.db_monitoring_role_arn
  multi_az                     = var.db_multi_az
  #parameters                   = var.db_parameters == null ? null : var.db_parameters
  pass_version                 = 1
  performance_insights_enabled = var.db_performance_insights_enabled
  skip_final_snapshot          = false
  subnet_group_name            = var.db_subnet_group
  storage                      = var.db_storage_size
  tags                         = var.tags
  vpc_id                       = local.db_vpc_id
}

resource "aws_route53_record" "this" {
  count   = var.zone_id != null ? 1 : 0
  name    = var.dns_prefix
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
