# terraform-aws-atlassian-bitbucket

[![tflint](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/workflows/tflint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/actions?query=workflow%3Atflint+event%3Apush+branch%3Amaster)
[![tfsec](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/workflows/tfsec/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amaster)
[![yamllint](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/workflows/yamllint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amaster)
[![misspell](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/workflows/misspell/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amaster)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/workflows/pre-commit-check/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amaster)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>

Creates an Atlassian Bitbucket instance, optionally bootstrapping the configuration.

## Example
```hcl
module "bitbucket" {
  source = "rhythmictech/atlassian-bitbucket/aws"

  admin_email                    = "me@rhythmic.dev"
  admin_password                 = "hunter2"
  ami_id                         = data.aws_ami.bitbucket.id
  asg_additional_iam_policies    = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  asg_instance_type              = "m6g.large"
  asg_subnet                     = "subnet-123456789"
  availability_zone              = "us-east-1a"
  data_volume_size               = 50
  db_instance_class              = "db.m5.large"
  db_storage_size                = 50
  db_subnet_group                = "database"
  dns_prefix                     = "bitbucket"
  elb_certificate                = "arn:aws:acm:us-east-1:012345678901:certificate/618601f5-bf87-13d4-a0f6-8a243a54af93"
  elb_subnets                    = ["subnet-123456789", "subnet-012345678"]
  site_name                      = "Bitbucket Demo"
  vpc_id                         = "vpc-123456789"
  zone_id                        = "zone-123456789"
}
```

## About
A bit about this module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.19 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.65 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 1.2 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.39.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bitbucketdb"></a> [bitbucketdb](#module\_bitbucketdb) | rhythmictech/rds-postgres/aws | 4.5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_ebs_volume.data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_elb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb.ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.alb_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb_https_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_https_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_inbound_from_lb_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_inbound_http_from_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_inbound_http_from_lb_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_egress_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_ingress_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_string.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_secretsmanager_secret_version.dbpassword](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [template_cloudinit_config.this](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_bucket"></a> [access\_logs\_bucket](#input\_access\_logs\_bucket) | The name of the bucket to store LB access logs in. Required if `access_logs_enabled` is `true` | `string` | `null` | no |
| <a name="input_access_logs_enabled"></a> [access\_logs\_enabled](#input\_access\_logs\_enabled) | Whether to enable LB access logging | `bool` | `false` | no |
| <a name="input_access_logs_interval"></a> [access\_logs\_interval](#input\_access\_logs\_interval) | The log publishing interval in minutes | `number` | `60` | no |
| <a name="input_access_logs_prefix"></a> [access\_logs\_prefix](#input\_access\_logs\_prefix) | The path prefix to apply to the LB access logs. | `string` | `null` | no |
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | email address for administrator | `string` | n/a | yes |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | initial password to use for administrator (only used when bootstrapping a new instance, otherwise ignored) | `string` | `null` | no |
| <a name="input_alb_additional_sg_tags"></a> [alb\_additional\_sg\_tags](#input\_alb\_additional\_sg\_tags) | Additional tags to apply to the LB security group. Useful if you use an external process to manage ingress rules. | `map(string)` | `{}` | no |
| <a name="input_alb_allowed_https_cidr_blocks"></a> [alb\_allowed\_https\_cidr\_blocks](#input\_alb\_allowed\_https\_cidr\_blocks) | List of allowed CIDR blocks. If `[]` is specified, no inbound ingress rules will be created | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_alb_allowed_ssh_cidr_blocks"></a> [alb\_allowed\_ssh\_cidr\_blocks](#input\_alb\_allowed\_ssh\_cidr\_blocks) | List of allowed CIDR blocks for SSH access. If `[]` is specified, no inbound ingress rules will be created | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_alb_certificate"></a> [alb\_certificate](#input\_alb\_certificate) | ARN of certificate to associate with LB | `string` | n/a | yes |
| <a name="input_alb_https_internal"></a> [alb\_https\_internal](#input\_alb\_https\_internal) | Create as an internal or internet-facing LB | `bool` | `true` | no |
| <a name="input_alb_https_port"></a> [alb\_https\_port](#input\_alb\_https\_port) | Port that the Load Balancer for Bitbucket should listen for HTTPS on (Default is 443.) | `number` | `443` | no |
| <a name="input_alb_https_subnets"></a> [alb\_https\_subnets](#input\_alb\_https\_subnets) | Subnets to associate HTTPS LB to | `list(string)` | n/a | yes |
| <a name="input_alb_ssh_internal"></a> [alb\_ssh\_internal](#input\_alb\_ssh\_internal) | Create as an internal or internet-facing LB for SSH | `bool` | `true` | no |
| <a name="input_alb_ssh_port"></a> [alb\_ssh\_port](#input\_alb\_ssh\_port) | Port that the Load Balancer for Bitbucket should listen for SSH on (Default is 22.) | `number` | `22` | no |
| <a name="input_alb_ssh_subnets"></a> [alb\_ssh\_subnets](#input\_alb\_ssh\_subnets) | Subnets to associate SSH LB to | `list(string)` | `null` | no |
| <a name="input_alb_ssl_policy"></a> [alb\_ssl\_policy](#input\_alb\_ssl\_policy) | SSL policy for ALB | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI to build on (must have `ansible-role-atlassian-bitbucket` module installed) | `string` | n/a | yes |
| <a name="input_asg_additional_iam_policies"></a> [asg\_additional\_iam\_policies](#input\_asg\_additional\_iam\_policies) | Additional IAM policies to attach to the  ASG instance profile | `list(string)` | `[]` | no |
| <a name="input_asg_additional_security_groups"></a> [asg\_additional\_security\_groups](#input\_asg\_additional\_security\_groups) | Additional security group IDs to attach to ASG instances | `list(string)` | `[]` | no |
| <a name="input_asg_additional_user_data"></a> [asg\_additional\_user\_data](#input\_asg\_additional\_user\_data) | Additional User Data to attach to the launch template | `string` | `""` | no |
| <a name="input_asg_allow_outbound_egress"></a> [asg\_allow\_outbound\_egress](#input\_asg\_allow\_outbound\_egress) | whether or not the default SG should allow outbound egress | `bool` | `true` | no |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | The number of Amazon EC2 instances that should be running in the group. | `number` | `1` | no |
| <a name="input_asg_instance_type"></a> [asg\_instance\_type](#input\_asg\_instance\_type) | Instance type for app | `string` | `"t3a.micro"` | no |
| <a name="input_asg_key_name"></a> [asg\_key\_name](#input\_asg\_key\_name) | Optional ssh keypair to associate with instances | `string` | `null` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | Maximum number of instances in the autoscaling group | `number` | `1` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | Minimum number of instances in the autoscaling group | `number` | `1` | no |
| <a name="input_asg_root_volume_size"></a> [asg\_root\_volume\_size](#input\_asg\_root\_volume\_size) | size of root volume (includes app install but not data dir) | `number` | `20` | no |
| <a name="input_asg_subnet"></a> [asg\_subnet](#input\_asg\_subnet) | Subnet to associate ASG instances with (specify no more than 1) | `string` | n/a | yes |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Specify the availability zone that the instance will be deployed in. Because Bitbucket requires an EBS volume for data and can't use EFS, the value of `availability_zone` must match the AZ associated with the value of `asg_subnet`. | `string` | n/a | yes |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Create an ALB. This will by requirement create an NLB for SSH access on a separate address. | `bool` | `false` | no |
| <a name="input_data_volume_size"></a> [data\_volume\_size](#input\_data\_volume\_size) | Size in GB of the data volume | `number` | n/a | yes |
| <a name="input_db_additional_security_groups"></a> [db\_additional\_security\_groups](#input\_db\_additional\_security\_groups) | SGs permitted access to RDS | `list(string)` | `[]` | no |
| <a name="input_db_allowed_access_cidrs"></a> [db\_allowed\_access\_cidrs](#input\_db\_allowed\_access\_cidrs) | CIDRs permitted access to RDS | `list(string)` | `[]` | no |
| <a name="input_db_engine_version"></a> [db\_engine\_version](#input\_db\_engine\_version) | engine version to run | `string` | `"11"` | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | DB Instance Size | `string` | `"db.t3.large"` | no |
| <a name="input_db_monitoring_interval"></a> [db\_monitoring\_interval](#input\_db\_monitoring\_interval) | Enhanced monitoring interval (5-60 seconds, 0 to disable) | `number` | `0` | no |
| <a name="input_db_monitoring_role_arn"></a> [db\_monitoring\_role\_arn](#input\_db\_monitoring\_role\_arn) | IAM Role ARN for Database Monitoring permissions (if `db_monitoring_interval > 0` and this is omitted, a role will be created automatically) | `string` | `null` | no |
| <a name="input_db_multi_az"></a> [db\_multi\_az](#input\_db\_multi\_az) | If true, DB will be configured in multi-AZ mode | `bool` | `false` | no |
| <a name="input_db_parameters"></a> [db\_parameters](#input\_db\_parameters) | DB parameters (by default only sets utf8 as required by Bitbucket) | <pre>list(object({<br>    apply_method = string<br>    name         = string<br>    value        = string<br>  }))</pre> | <pre>[<br>  {<br>    "apply_method": "immediate",<br>    "name": "client_encoding",<br>    "value": "UTF8"<br>  }<br>]</pre> | no |
| <a name="input_db_password_version"></a> [db\_password\_version](#input\_db\_password\_version) | Increment to force master user password change | `number` | `1` | no |
| <a name="input_db_performance_insights_enabled"></a> [db\_performance\_insights\_enabled](#input\_db\_performance\_insights\_enabled) | Whether or not to enable DB performance insights | `bool` | `false` | no |
| <a name="input_db_storage_size"></a> [db\_storage\_size](#input\_db\_storage\_size) | Size of DB (in GB) | `number` | n/a | yes |
| <a name="input_db_subnet_group"></a> [db\_subnet\_group](#input\_db\_subnet\_group) | Database subnet group | `string` | n/a | yes |
| <a name="input_db_vpc_id"></a> [db\_vpc\_id](#input\_db\_vpc\_id) | VPC ID for database (if omitted, the value for `vpc_id` is used instead) | `string` | `null` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | Hostname that will be used for bitbucket. This will be combined with the domain in `zone_id` or the value of `domain_name` to form the base url. | `string` | `null` | no |
| <a name="input_dns_ssh_prefix"></a> [dns\_ssh\_prefix](#input\_dns\_ssh\_prefix) | Hostname that will be used for bitbucket SSH access. This is only used when `create_alb == true` | `string` | `null` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | domain name, which is only used if `zone_id` is not specified to compute the base url | `string` | `null` | no |
| <a name="input_elb_additional_sg_tags"></a> [elb\_additional\_sg\_tags](#input\_elb\_additional\_sg\_tags) | Additional tags to apply to the ELB security group. Useful if you use an external process to manage ingress rules. | `map(string)` | `{}` | no |
| <a name="input_elb_allowed_cidr_blocks"></a> [elb\_allowed\_cidr\_blocks](#input\_elb\_allowed\_cidr\_blocks) | List of allowed CIDR blocks. If `[]` is specified, no inbound ingress rules will be created | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_elb_certificate"></a> [elb\_certificate](#input\_elb\_certificate) | ARN of certificate to associate with ELB | `string` | `null` | no |
| <a name="input_elb_internal"></a> [elb\_internal](#input\_elb\_internal) | Create as an internal or internet-facing ELB | `bool` | `true` | no |
| <a name="input_elb_port"></a> [elb\_port](#input\_elb\_port) | Port that the Elastic Load Balancer for Bitbucket should listen for HTTPS on (Default is 443.) | `number` | `443` | no |
| <a name="input_elb_ssh_port"></a> [elb\_ssh\_port](#input\_elb\_ssh\_port) | Port that the Elastic Load Balancer for Bitbucket should listen for SSH on (Default is 22.) | `number` | `22` | no |
| <a name="input_elb_subnets"></a> [elb\_subnets](#input\_elb\_subnets) | Subnets to associate ELB to | `list(string)` | `null` | no |
| <a name="input_license_key"></a> [license\_key](#input\_license\_key) | Bitbucket license key (optional, must be a single line) | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Moniker to apply to all resources in the module | `string` | `"bitbucket"` | no |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | Bitbucket site name | `string` | `"Bitbucket"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | User-Defined tags | `map(string)` | `{}` | no |
| <a name="input_volume_key"></a> [volume\_key](#input\_volume\_key) | This value is set to a key on the EBS volume and must be present for the bitbucket instance to be permitted to attach it. | `string` | `"bitbucket-volume"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC to create associated resources in | `string` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Zone ID to make Route53 entry for bitbucket in. If not specified, `domain_name` must be specified so that the base URL can be determined. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | ARN of the ASG for the Bitbucket instance |
| <a name="output_asg_id"></a> [asg\_id](#output\_asg\_id) | ID of the ASG for the Bitbucket instance |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | Name of the ASG for the Bitbucket instance |
| <a name="output_db_instance_connection_info"></a> [db\_instance\_connection\_info](#output\_db\_instance\_connection\_info) | DB Instance Connect Info (object) |
| <a name="output_db_instance_id"></a> [db\_instance\_id](#output\_db\_instance\_id) | DB Instance ID |
| <a name="output_db_password_secretsmanager_arn"></a> [db\_password\_secretsmanager\_arn](#output\_db\_password\_secretsmanager\_arn) | Secret ARN for DB password |
| <a name="output_db_password_secretsmanager_version"></a> [db\_password\_secretsmanager\_version](#output\_db\_password\_secretsmanager\_version) | Secret Version for DB password |
| <a name="output_db_username"></a> [db\_username](#output\_db\_username) | Master username |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | IAM Role ARN of Bitbucket instance |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | ARN of the ELB for Bitbucket access (HTTPS when ALB is used) |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | DNS Name of the ELB for Bitbucket access |
| <a name="output_lb_zone_id"></a> [lb\_zone\_id](#output\_lb\_zone\_id) | Route53 Zone ID of the ELB for Bitbucket access |
| <a name="output_ssh_lb_arn"></a> [ssh\_lb\_arn](#output\_ssh\_lb\_arn) | ARN of the LB for Bitbucket SSH access (only valid when ALB is used) |
| <a name="output_ssh_lb_dns_name"></a> [ssh\_lb\_dns\_name](#output\_ssh\_lb\_dns\_name) | DNS Name of the LB for Bitbucket access (only valid when ALB is used) |
| <a name="output_ssh_lb_zone_id"></a> [ssh\_lb\_zone\_id](#output\_ssh\_lb\_zone\_id) | Route53 Zone ID of the LB for Bitbucket SSH access |
| <a name="output_url"></a> [url](#output\_url) | Bitbucket Server URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## The Giants Underneath this Module
- [pre-commit.com](pre-commit.com)
- [terraform.io](terraform.io)
- [github.com/tfutils/tfenv](github.com/tfutils/tfenv)
- [github.com/segmentio/terraform-docs](github.com/segmentio/terraform-docs)
