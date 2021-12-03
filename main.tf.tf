resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "Deployer Key"
  public_key = tls_private_key.ssh_key.public_key_openssh

  tags = {
    Name = "Deployer Key"
  }
}

resource "aws_security_group" "virtual_key_sg" {
  description = "SG to test Virtual Key SSH."
  name        = "Virtual Key"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "HTTP Traffic"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "SSH"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]

  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Outgoing Traffic"
      from_port        = 0
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  tags = {
    Name = "Virtual Key SG"
  }
}

resource "aws_instance" "virtual_key" {
  ami           = data.aws_ami.amazon_linux_free_tier.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer_key.key_name
  vpc_security_group_ids = [

    aws_security_group.virtual_key_sg.id
  ]

  tags = {
    Name = "Virtual Key Instance"
  }
}

