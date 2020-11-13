data "aws_region" "current" {
}

data "template_cloudinit_config" "this" {

  part {
    content_type = "text/x-shellscript"
    content      = local.configure_script
  }

  part {
    content_type = "text/x-shellscript"
    content      = var.asg_additional_user_data
  }
}

data "aws_route53_zone" "zone" {
  count   = var.zone_id == null ? 0 : 1
  zone_id = var.zone_id
}

data "aws_secretsmanager_secret_version" "dbpassword" {
  secret_id = module.bitbucketdb.password_secretsmanager_arn
}

resource "random_string" "admin_password" {
  length  = 16
  special = false
}

locals {
  admin_password = coalesce(var.admin_password, random_string.admin_password.result)
  bitbucket_url  = "${var.dns_prefix}.${local.domain_name}"
  db_name        = replace(local.short_name, "-", "")
  db_vpc_id      = coalesce(var.db_vpc_id, var.vpc_id)
  domain_name    = try(trimsuffix(data.aws_route53_zone.zone[0].name, "."), var.domain_name)
  region         = data.aws_region.current.name
  short_name     = substr(var.name, 0, 32)

  configure_script = templatefile("${path.module}/templates/configure.sh.tpl",
    {
      admin_email    = var.admin_email
      admin_password = local.admin_password
      base_hostname  = local.bitbucket_url
      db_url         = "jdbc:postgresql://${module.bitbucketdb.instance_connection_info.endpoint}/postgres"
      db_username    = module.bitbucketdb.instance_connection_info.username
      db_password    = replace(data.aws_secretsmanager_secret_version.dbpassword.secret_string, "$", "\\$")
      license_key    = var.license_key
      mount_point    = "/opt/atlassian/data"
      region         = local.region
      site_name      = var.site_name
      volume_id      = aws_ebs_volume.data.id
    }
  )

  db_allowed_security_groups = concat(
    [aws_security_group.this.id],
    var.db_additional_security_groups
  )
}

resource "aws_ebs_volume" "data" {
  availability_zone = var.availability_zone
  size              = var.data_volume_size

  tags = merge(var.tags,
    { VolumeKey = var.volume_key }
  )
}

resource "aws_autoscaling_group" "this" {
  name_prefix               = var.name
  desired_capacity          = var.asg_desired_capacity
  health_check_grace_period = 600
  health_check_type         = "EC2"
  force_delete              = false
  launch_configuration      = aws_launch_configuration.this.name
  load_balancers            = [aws_elb.this.id]
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  wait_for_capacity_timeout = "15m"
  vpc_zone_identifier       = [var.asg_subnet]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = var.name
  }

  tag {
    key                 = "VolumeKey"
    propagate_at_launch = true
    value               = var.volume_key
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      propagate_at_launch = true
      value               = tag.value
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

  root_block_device {
    encrypted   = true
    volume_size = var.asg_root_volume_size
  }

  security_groups = concat(
    var.asg_additional_security_groups,
    [aws_security_group.this.id]
  )

  lifecycle {
    create_before_destroy = true
  }
}

module "bitbucketdb" {
  source  = "rhythmictech/rds-postgres/aws"
  version = "4.2.0"

  name                    = local.db_name
  allowed_cidr_blocks     = var.db_allowed_access_cidrs
  allowed_security_groups = local.db_allowed_security_groups
  # bitbucket DB backups aren't consistent and need to be managed externally, one backup is stored just for emergency use
  backup_retention_period      = 1
  engine_version               = var.db_engine_version
  identifier_prefix            = local.short_name
  instance_class               = var.db_instance_class
  monitoring_interval          = var.db_monitoring_interval
  monitoring_role_arn          = var.db_monitoring_role_arn
  multi_az                     = var.db_multi_az
  parameters                   = var.db_parameters
  pass_version                 = var.db_password_version
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
    name                   = aws_elb.this.dns_name
    zone_id                = aws_elb.this.zone_id
    evaluate_target_health = true
  }
}
