variable "project_prefix" {
  type = string
}

variable "region" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "session_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
}

variable "subnetNames" {
  type        = list(string)
  description = "A list of public subnets inside the vNet"
}

variable "subnetPrefixes" {
  type        = list(string)
  description = "The address prefix to use for the subnet"
}

variable "availabilityZone" {
  type        = list(string)
  description = "The address prefix to use for the subnet"
}

variable "public_key" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "min_size" {
  type = string
}

variable "max_size" {
  type = string
}

variable "desired_capacity" {
  type = string
}