########################################
# General Vars
########################################

variable "name" {
  default     = "bitbucket"
  description = "Moniker to apply to all resources in the module"
  type        = string
}

variable "tags" {
  default     = {}
  description = "User-Defined tags"
  type        = map(string)
}

########################################
# Bitbucket Vars
########################################

variable "admin_email" {
  description = "email address for administrator"
  type        = string
}

variable "admin_password" {
  default     = null
  description = "initial password to use for administrator (only used when bootstrapping a new instance, otherwise ignored)"
  type        = string
}

variable "data_volume_size" {
  description = "Size in GB of the data volume"
  type        = number
}

variable "dns_prefix" {
  default     = null
  description = "the hostname that will be used for bitbucket. This will be combined with the domain in `zone_id` or the value of `domain_name` to form the base url."
  type        = string
}

variable "domain_name" {
  default     = null
  description = "domain name, which is only used if `zone_id` is not specified to compute the base url"
  type        = string
}

variable "license_key" {
  default     = ""
  description = "Bitbucket license key (optional, must be a single line)"
  type        = string
}

variable "site_name" {
  default     = "Bitbucket"
  description = "Bitbucket site name"
  type        = string
}

variable "volume_key" {
  default     = "bitbucket-volume"
  description = "This value is set to a key on the EBS volume and must be present for the bitbucket instance to be permitted to attach it."
  type        = string
}

########################################
# ASG Vars
########################################

variable "ami_id" {
  description = "AMI to build on (must have `ansible-role-atlassian-bitbucket` module installed)"
  type        = string
}

variable "asg_additional_iam_policies" {
  default     = []
  description = "Additional IAM policies to attach to the  ASG instance profile"
  type        = list(string)
}

variable "asg_additional_security_groups" {
  default     = []
  description = "Additional security group IDs to attach to ASG instances"
  type        = list(string)
}

variable "asg_additional_user_data" {
  default     = ""
  description = "Additional User Data to attach to the launch template"
  type        = string
}

variable "asg_allow_outbound_egress" {
  default     = true
  description = "whether or not the default SG should allow outbound egress"
  type        = bool
}

variable "asg_desired_capacity" {
  default     = 1
  description = "The number of Amazon EC2 instances that should be running in the group."
  type        = number
}

variable "asg_instance_type" {
  default     = "t3a.micro"
  description = "Instance type for app"
  type        = string
}

variable "asg_key_name" {
  default     = null
  description = "Optional ssh keypair to associate with instances"
  type        = string
}

variable "asg_max_size" {
  default     = 1
  description = "Maximum number of instances in the autoscaling group"
  type        = number
}

variable "asg_min_size" {
  default     = 1
  description = "Minimum number of instances in the autoscaling group"
  type        = number
}

variable "asg_root_volume_size" {
  default     = 20
  description = "size of root volume (includes app install but not data dir)"
  type        = number
}

variable "asg_subnet" {
  description = "Subnet to associate ASG instances with (specify no more than 1)"
  type        = string
}

#################################################
# DB Settings
#################################################

variable "db_additional_security_groups" {
  default     = []
  description = "SGs permitted access to RDS"
  type        = list(string)
}

variable "db_allowed_access_cidrs" {
  default     = []
  description = "CIDRs permitted access to RDS"
  type        = list(string)
}

variable "db_engine_version" {
  default     = "11"
  description = "engine version to run"
  type        = string
}

variable "db_instance_class" {
  default     = "db.t3.large"
  description = "DB Instance Size"
  type        = string
}

variable "db_multi_az" {
  default     = false
  description = "If true, DB will be configured in multi-AZ mode"
  type        = bool
}

variable "db_monitoring_role_arn" {
  default     = null
  description = "IAM Role ARN for Database Monitoring permissions (if `db_monitoring_interval > 0` and this is omitted, a role will be created automatically)"
  type        = string
}

variable "db_monitoring_interval" {
  default     = 0
  description = "Enhanced monitoring interval (5-60 seconds, 0 to disable)"
  type        = number
}

variable "db_parameters" {
  description = "DB parameters (by default only sets utf8 as required by Bitbucket)"

  default = [
    {
      name  = "client_encoding"
      value = "UTF8"
    }
  ]

  type = list(object({
    name  = string
    value = string
  }))
}

variable "db_password_version" {
  default     = 1
  description = "Increment to force master user password change"
  type        = number
}

variable "db_performance_insights_enabled" {
  default     = false
  description = "Whether or not to enable DB performance insights"
  type        = bool
}

variable "db_storage_size" {
  description = "Size of DB (in GB)"
  type        = number
}

variable "db_subnet_group" {
  description = "Database subnet group"
  type        = string
}

variable "db_vpc_id" {
  default     = null
  description = "VPC ID for database (if omitted, the value for `vpc_id` is used instead)"
  type        = string
}

########################################
# Networking Vars
########################################

variable "availability_zone" {
  description = "Specify the availability zone that the instance will be deployed in. Because Bitbucket requires an EBS volume for data and can't use EFS, the value of `availability_zone` must match the AZ associated with the value of `asg_subnet`."
  type        = string
}

variable "elb_additional_sg_tags" {
  default     = {}
  description = "Additional tags to apply to the ELB security group. Useful if you use an external process to manage ingress rules."
  type        = map(string)
}

variable "elb_allowed_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  description = "List of allowed CIDR blocks. If `[]` is specified, no inbound ingress rules will be created"
  type        = list(string)
}

variable "elb_certificate" {
  description = "ARN of certificate to associate with ELB"
  type        = string
}

variable "elb_internal" {
  default     = true
  description = "Create as an internal or internet-facing ELB"
  type        = bool
}

variable "elb_port" {
  default     = 443
  description = "Port that the Elastic Load Balancer for Bitbucket should listen on (Default is 443.)"
  type        = number
}

variable "elb_ssh_port" {
  default     = 22
  description = "Port that the Elastic Load Balancer for Bitbucket should listen for SSH on (Default is 22.)"
  type        = number
}

variable "elb_subnets" {
  description = "Subnets to associate ELB to"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC to create associated resources in"
  type        = string
}

variable "zone_id" {
  default     = null
  description = "Zone ID to make Route53 entry for bitbucket in. If not specified, `domain_name` must be specified so that the base URL can be determined."
  type        = string
}
