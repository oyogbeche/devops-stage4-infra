resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated_key" {
  key_name   = "stage4-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.my_key.private_key_pem
  filename = "${path.module}/../stage4-key.pem"
}

resource "aws_security_group" "stage4_sg" {
  name_prefix = "stage4-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
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
resource "aws_instance" "stage4_inst" {
  ami             = "ami-0715d656023fe21b4"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.generated_key.key_name
  security_groups = [aws_security_group.stage4_sg.name]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "web ansible_host=${self.public_ip} ansible_user=ubuntu" >> "${path.module}/../ansible/inventory.ini"
    EOT
  }
}

resource "null_resource" "run_ansible" {
  depends_on = [aws_instance.stage4_inst]

  provisioner "local-exec" {
    command = <<EOT
      chmod 600 ../stage4-key.pem && \
      ansible-playbook -i ../ansible/inventory.ini ../ansible/dependencies.yaml ../ansible/deploy.yaml --private-key=../stage4-key.pem --extra-vars "nostricthostchecking=true"
EOT
  }
}

