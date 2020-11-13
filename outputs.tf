output "asg_arn" {
  description = "ARN of the ASG for the Bitbucket instance"
  value       = aws_autoscaling_group.this.arn
}

output "asg_id" {
  description = "ID of the ASG for the Bitbucket instance"
  value       = aws_autoscaling_group.this.id
}

output "asg_name" {
  description = "Name of the ASG for the Bitbucket instance"
  value       = aws_autoscaling_group.this.name
}

output "db_instance_connection_info" {
  description = "DB Instance Connect Info (object)"
  value       = module.bitbucketdb.instance_connection_info
}

output "db_instance_id" {
  description = "DB Instance ID"
  value       = module.bitbucketdb.instance_id
}

output "db_password_secretsmanager_arn" {
  description = "Secret ARN for DB password"
  value       = module.bitbucketdb.password_secretsmanager_arn
}

output "db_password_secretsmanager_version" {
  description = "Secret Version for DB password"
  value       = module.bitbucketdb.password_secretsmanager_version
}

output "db_username" {
  description = "Master username"
  value       = module.bitbucketdb.username
}

output "iam_role_arn" {
  description = "IAM Role ARN of Bitbucket instance"
  value       = aws_iam_role.this.arn
}

output "lb_arn" {
  description = "ARN of the ELB for Bitbucket access"
  value       = aws_elb.this.arn
}

output "lb_dns_name" {
  description = "DNS Name of the ELB for Bitbucket access"
  value       = aws_elb.this.dns_name
}

output "lb_zone_id" {
  description = "Route53 Zone ID of the ELB for Bitbucket access"
  value       = aws_elb.this.zone_id
}

output "url" {
  description = "Bitbucket Server URL"
  value       = local.bitbucket_url
}
