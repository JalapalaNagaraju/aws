variable "tags" {}
variable "cidr_block" {}
variable project_prefix {}

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