output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = module.vpc.subnet_ids
}

output "internal_sg" {
  value = module.vpc.internal_sg
}

output "elb_sg" {
  value = module.vpc.elb_sg
}