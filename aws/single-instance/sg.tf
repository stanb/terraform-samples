resource "aws_security_group" "sg_ssh" {
  name = "ssh_sg"
  description = "Enable SSH access via port 22"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sandbox_id}-ssh-sg"
    Owner = "${var.owner}"
  }
}
