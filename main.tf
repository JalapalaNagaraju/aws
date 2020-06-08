module "vpc" {
  source           = "./modules/vpc"
  cidr_block       = var.cidr_block
  project_prefix   = var.project_prefix
  subnetPrefixes   = var.subnetPrefixes
  availabilityZone = var.availabilityZone
  subnetNames      = var.subnetNames
  tags             = var.tags
}

/*
module "ec2" {
  source         = "./modules/ec2"
  vpc_id         = "${module.vpc.vpc_id}"
  project_prefix = var.project_prefix
  subnet_ids     = "${module.vpc.subnet_ids}"
  internal_sg    = "${module.vpc.internal_sg}"
  elb_sg         = "${module.vpc.elb_sg}"
  tags           = var.tags
  public_key     = var.public_key
  instance_type  = var.instance_type
}
*/

module "elb" {
  source           = "./modules/elb"
  vpc_id           = "${module.vpc.vpc_id}"
  project_prefix   = var.project_prefix
  subnet_ids       = "${module.vpc.subnet_ids}"
  internal_sg      = "${module.vpc.internal_sg}"
  elb_sg           = "${module.vpc.elb_sg}"
  tags             = var.tags
  public_key       = var.public_key
  instance_type    = var.instance_type
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size
}

/*
module "elb2" {
  source           = "./modules/elb"
  vpc_id           = "${module.vpc.vpc_id}"
  project_prefix   = var.project_prefix
  subnet_ids       = "${module.vpc.subnet_ids}"
  internal_sg      = "${module.vpc.internal_sg}"
  elb_sg           = "${module.vpc.elb_sg}"
  tags             = local.project2_tags
  public_key       = var.public_key
  instance_type    = var.instance_type
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size
}
*/