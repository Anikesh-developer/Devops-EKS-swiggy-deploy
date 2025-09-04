resource "random_id" "suffix" {
  byte_length = 2
}

resource "aws_security_group" "Project-SG" {
  name        = "Project-SG-${random_id.suffix.hex}"
  description = "Open 22, 80, 443, 8080, 9000, 3000, 30000"
  vpc_id      = module.vpc.vpc_id

# Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000, 30000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Project-SG-${random_id.suffix.hex}"
  }
}