# terraform-aws-atlassian-bitbucket

[![tflint](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/workflows/tflint/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/actions?query=workflow%3Atflint+event%3Apush+branch%3Amain)
[![tfsec](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/workflows/tfsec/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amain)
[![yamllint](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/workflows/yamllint/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amain)
[![misspell](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/workflows/misspell/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amain)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/workflows/pre-commit-check/badge.svg?branch=main&event=push)](https://github.com/rhythmictech/terraform-aws-atlassian-bitbucket/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amain)
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
| terraform | >= 0.12.19 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_email | email address for administrator | `string` | n/a | yes |
| admin\_password | initial password to use for administrator | `string` | n/a | yes |
| ami\_id | AMI to build on (must have `ansible-role-atlassian-bitbucket` module installed) | `string` | n/a | yes |
| asg\_subnet | Subnet to associate ASG instances with (specify no more than 1) | `string` | n/a | yes |
| availability\_zone | Specify the availability zone that the instance will be deployed in. Because Bitbucket requires an EBS volume for data and can't use EFS, the value of `availability_zone` must match the AZ associated with the value of `asg_subnet`. | `string` | n/a | yes |
| data\_volume\_size | Size in GB of the data volume | `number` | n/a | yes |
| db\_instance\_class | DB Instance Size | `string` | n/a | yes |
| db\_storage\_size | Size in DB (in GB) | `number` | n/a | yes |
| db\_subnet\_group | Database subnet group | `string` | n/a | yes |
| elb\_certificate | ARN of certificate to associate with ELB | `string` | n/a | yes |
| elb\_subnets | Subnets to associate ELB to | `list(string)` | n/a | yes |
| vpc\_id | VPC to create associated resources in | `string` | n/a | yes |
| asg\_additional\_iam\_policies | Additional IAM policies to attach to the  ASG instance profile | `list(string)` | `[]` | no |
| asg\_additional\_security\_groups | Additional security group IDs to attach to ASG instances | `list(string)` | `[]` | no |
| asg\_additional\_user\_data | Additional User Data to attach to the launch template | `string` | `""` | no |
| asg\_allow\_outbound\_egress | whether or not the default SG should allow outbound egress | `bool` | `true` | no |
| asg\_desired\_capacity | The number of Amazon EC2 instances that should be running in the group. | `number` | `1` | no |
| asg\_instance\_type | Instance type for scim app | `string` | `"t3a.micro"` | no |
| asg\_key\_name | Optional keypair to associate with instances | `string` | `null` | no |
| asg\_max\_size | Maximum number of instances in the autoscaling group | `number` | `2` | no |
| asg\_min\_size | Minimum number of instances in the autoscaling group | `number` | `1` | no |
| asg\_root\_volume\_size | size of root volume (includes app install but not data dir) | `number` | `20` | no |
| db\_additional\_security\_groups | SGs permitted access to RDS | `list(string)` | `[]` | no |
| db\_allowed\_access\_cidrs | CIDRs permitted access to RDS | `list(string)` | `[]` | no |
| db\_engine\_version | engine version to run | `string` | `"11"` | no |
| db\_monitoring\_interval | Enhanced monitoring interval (5-60 seconds, 0 to disable) | `number` | `0` | no |
| db\_monitoring\_role\_arn | ARN for Database Monitoring (required for performance insights) | `string` | `null` | no |
| db\_multi\_az | If true, DB will be configured in multi-AZ mode | `bool` | `false` | no |
| db\_parameters | DB parameters (downstream module defaults will be used if not specified) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "client_encoding",<br>    "value": "UTF8"<br>  }<br>]</pre> | no |
| db\_performance\_insights\_enabled | Whether or not to enable DB performance insights | `bool` | `false` | no |
| db\_vpc\_id | VPC ID for database (if omitted, the value for `vpc_id` is used instead) | `string` | `null` | no |
| dns\_prefix | the hostname that will be used for bitbucket. This will be combined with the domain in `zone_id` or the value of `domain_name` to form the base url. | `string` | `null` | no |
| domain\_name | domain name, which is only used if `zone_id` is not specified to compute the base url | `string` | `null` | no |
| elb\_additional\_sg\_tags | Additional tags to apply to the ELB security group. Useful if you use an external process to manage ingress rules. | `map(string)` | `{}` | no |
| elb\_allowed\_cidr\_blocks | List of allowed CIDR blocks. If `[]` is specified, no inbound ingress rules will be created | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| elb\_internal | Create as an internal or internet-facing ELB | `bool` | `true` | no |
| license\_key | Bitbucket license key (optional, must be a single line) | `string` | `""` | no |
| name | Moniker to apply to all resources in the module | `string` | `"bitbucket"` | no |
| site\_name | Bitbucket site name | `string` | `"Bitbucket"` | no |
| tags | User-Defined tags | `map(string)` | `{}` | no |
| volume\_key | This value is set to a key on the EBS volume and must be present for the bitbucket instance to be permitted to attach it. | `string` | `"bitbucket-volume"` | no |
| zone\_id | Zone ID to make Route53 entry for bitbucket in. If not specified, `domain_name` must be specified so that the base URL can be determined. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| db\_instance\_connection\_info | DB Instance Connect Info (object) |
| db\_instance\_id | DB Instance ID |
| db\_password\_secretsmanager\_arn | Secret ARN for DB password |
| db\_password\_secretsmanager\_version | Secret Version for DB password |
| db\_username | Master username |
| iam\_role\_arn | IAM Role ARN of Bitbucket instance |
| lb\_arn | ARN of the ELB for Bitbucket access |
| lb\_dns\_name | DNS Name of the ELB for Bitbucket access |
| lb\_zone\_id | Route53 Zone ID of the ELB for Bitbucket access |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## The Giants Underneath this Module
- [pre-commit.com](pre-commit.com)
- [terraform.io](terraform.io)
- [github.com/tfutils/tfenv](github.com/tfutils/tfenv)
- [github.com/segmentio/terraform-docs](github.com/segmentio/terraform-docs)
