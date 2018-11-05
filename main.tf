provider "aws" "test-web" {
  region = "eu-central-1"
  profile = "terraform"
}

resource "aws_elb" "web" {
    name = "terraform"

    listener {
        instance_port       = 80
        instance_protocol   = "http"
        lb_port             = 80
        lb_protocol         = "http"
    }

    availability_zones = ["${aws_instance.runner.*.availability_zone}"]

    instances = ["${aws_instance.runner.*.id}"]
}
 
resource "aws_instance" "runner" {
  count = 2
  
  ami = "ami-9a91b371"
  instance_type = "t2.micro"
  key_name = "developer-key"
  vpc_security_group_ids = ["sg-2eec7943"]
  tags {
    Name = "runner-os"
  }
}
