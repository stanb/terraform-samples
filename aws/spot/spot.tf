variable "sandbox_id" {}
variable "owner" {}
variable "key_name" {}

provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "..//modules//vpc"
  sandbox_id = "${var.sandbox_id}"
  owner = "${var.owner}"
}
