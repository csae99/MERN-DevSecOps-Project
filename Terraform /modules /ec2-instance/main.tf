resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name
  user_data              = var.user_data

  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp3"
  }

  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = "Allow SSH and app ports"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
