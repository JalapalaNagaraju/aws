provider "aws" {
  region = var.region
  assume_role {
    role_arn     = var.role_arn
    session_name = var.session_name
  }
}