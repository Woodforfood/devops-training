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
  
  ami = "ami-0233214e13e500f77"
  instance_type = "t2.micro"
  key_name = "developer-key"
  vpc_security_group_ids = ["sg-2eec7943"]
  tags {
    Name = "runner-os"
  }
}
provisioner "remote-exec" {
  connection {
    type     = "ssh"
    user     = "ec2-user"
    }
 
    inline = [
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo docker pull nginx",
      "sudo docker run -d -p 80:80 -v /tmp:/usr/share/nginx/html --name nginx_${count.index} nginx"
    ]
  }
data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "bucket-0f63787397203f5cd"
    key    = ".terraform/terraform.tfstate"
    region = "eu-central-1"
  }  
}
