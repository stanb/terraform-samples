variable "sandbox_id" {}
variable "owner" {}
variable "key_name" {}

provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "../modules/vpc"
  sandbox_id = "${var.sandbox_id}"
  owner = "${var.owner}"
}

resource "aws_instance" "instance" {
  ami = "ami-0773391ae604c49a4"
  instance_type = "t3.micro"
  subnet_id = "${module.vpc.public_subnet1_id}"
  key_name = "${var.key_name}"
  
  vpc_security_group_ids = [
      "${aws_security_group.sg_ssh.id}"
  ]
  
  tags = {
    Name = "${var.sandbox_id}-instance"
    Owner = "${var.owner}"
  }
  
  connection {
    host = "${aws_instance.instance.public_ip}"
    user = "ubuntu"
    private_key = "${file("~/.aws/${var.key_name}.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "pwd"
    ]
  }
}

output "instance_public_ip" {
  value = "${aws_instance.instance.public_ip}"
}
