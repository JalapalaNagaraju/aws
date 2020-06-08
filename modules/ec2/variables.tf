variable "public_key" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnets inside the VPC"
}

variable "internal_sg" {
  type = string
}

variable "elb_sg" {
  type = string
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
}

variable "project_prefix" {
  type = string
}