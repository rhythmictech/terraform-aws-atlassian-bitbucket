# AMI must include the `ansible-role-atlassian-bitbucket` role.
data "aws_ami" "bitbucket" {
  most_recent = true

  owners = ["self"]

  filter {
    name   = "name"
    values = ["bitbucket-*"]

  }
}
module "bitbucket" {
  source = "../.."

  admin_email                 = "me@rhythmic.dev"
  admin_password              = "hunter2" #tfsec:ignore:GEN003
  ami_id                      = data.aws_ami.bitbucket.id
  asg_additional_iam_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  asg_instance_type           = "m6g.large"
  asg_subnet                  = "subnet-123456789"
  availability_zone           = "us-east-1a"
  data_volume_size            = 50
  db_instance_class           = "db.m5.large"
  db_storage_size             = 50
  db_subnet_group             = "database"
  dns_prefix                  = "bitbucket"
  elb_certificate             = "arn:aws:acm:us-east-1:012345678901:certificate/618601f5-bf87-13d4-a0f6-8a243a54af93"
  elb_subnets                 = ["subnet-123456789", "subnet-012345678"]
  site_name                   = "Bitbucket Demo"
  vpc_id                      = "vpc-123456789"
  zone_id                     = "zone-123456789"
}
