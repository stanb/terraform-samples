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

locals {
  timestamp =  "${timestamp()}"  
}

resource "aws_network_interface" "nic" {
  subnet_id = "${module.vpc.public_subnet1_id}"
  security_groups = ["${aws_security_group.sg_ssh.id}"]
}

resource "aws_eip" "eip" {
  vpc = true
  network_interface = "${aws_network_interface.nic.id}"
}

resource "aws_launch_template" "launch_template" {
  name     = "${var.sandbox_id}-lt"
  key_name = "${var.key_name}"
  image_id = "ami-0773391ae604c49a4"
  
  instance_market_options {
    spot_options {
      spot_instance_type = "persistent"
    }
    market_type="spot"
  }
  
  network_interfaces {
    device_index = 0
    network_interface_id = "${aws_network_interface.nic.id}"
  }
  network_interfaces {
    device_index = 1
    subnet_id = "${module.vpc.public_subnet1_id}"
  }
  
  # user_data = "${base64encode()}"
  
  tag_specifications {
    resource_type = "instance"
    tags {
      Name = "${var.sandbox_id}-instance"
      Owner = "${var.owner}"
    }
  }
}

# resource "aws_iam_role" "spot_fleet_tagging_role" {
#   name = "${var.sandbox_id}-ec2-spot-fleet-tagging-role"
#   assume_role_policy =  <<EOF
# {
#   'Version': '2012-10-17',
#   'Statement': [
#     {
#         'Action': 'sts:AssumeRole',
#         'Effect': 'Allow',
#         'Principal': {
#             'Service': 'spotfleet.amazonaws.com'
#         }
#     }
#   ]
# }
# EOF
  

#   tags {
#     Owner = "${var.owner}"
#     SandboxId = "${var.sandbox_id}"
#   }
# }

# resource "aws_iam_role_policy_attachment" "name" {
#   role = "${aws_iam_role.spot_fleet_tagging_role.id}"
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
# }

# resource "aws_iam_instance_profile" "spot_fleet_instance_profile" {
#   name = "${var.sandbox_id}-ec2-spot-fleet-instance-profile"
#   role = "${aws_iam_role.spot_fleet_tagging_role.id}"
# }


resource "aws_ec2_fleet" "fleet" {
  #iam_fleet_role = "${aws_iam_role.spot_fleet_tagging_role.id}"
  launch_template_config {
    launch_template_specification {
      launch_template_id = "${aws_launch_template.launch_template.id}"
      version            = "${aws_launch_template.launch_template.latest_version}"
    }
    # allow to choose from several instance types if there is no spot capacity for some type
    override {
      instance_type = "t2.micro"
    }
    override {
      instance_type = "t3.micro"
    }
    override {
      instance_type = "t3.small"
    }
  }

  target_capacity_specification {
    default_target_capacity_type = "spot"
    total_target_capacity = 1
  }
}

output "instance_public_ip" {
  value = "${aws_eip.eip.public_ip}"
}

output "describe_fleet_history" {
  value = "aws ec2 describe-fleet-history --fleet-id ${aws_ec2_fleet.fleet.id} --start-time "
}
