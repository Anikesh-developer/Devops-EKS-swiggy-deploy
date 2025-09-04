provider "aws" {
  region = "eu-north-1"
}


resource "aws_instance" "example" {
  ami           = "ami-0a716d3f3b16d290c" # Ubuntu
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.Project-SG.id]
  user_data = templatefile("./resource.sh", {})

  tags = {
    Name = "Microservice_Application"
  }
  root_block_device {
    volume_size = 30         # Root disk size in GB
    volume_type = "gp3"      # gp2/gp3 etc.
    delete_on_termination = true
  }

}
