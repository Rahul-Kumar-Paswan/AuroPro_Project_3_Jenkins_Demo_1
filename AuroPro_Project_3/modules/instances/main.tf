resource "tls_private_key" "ssh_private_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "my-key-pair"
  public_key = tls_private_key.ssh_private_key.public_key_openssh
}

resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.latest-amazon-image.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.ssh_key.key_name  # Associate the key pair with the instance
  tags = {
    Name = var.instance_name
  }
  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]

  associate_public_ip_address = true

  # user_data = file("entry-script.sh")
  # user_data = file("${path.module}/entry-script.sh")
  user_data = file("entry-script.sh")


  # provisioner "file" {
  #   source = "/root/flask-jenkins-deploy/mydockercompose.yml"
  #   destination = "/home/ec2-user/"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum update -y",
  #     "sudo yum install docker -y",
  #     "sudo service docker start",
  #     "sudo usermod -a -G docker ec2-user",
  #     "sudo chmod 666 /var/run/docker.sock",
  #     "sudo service docker restart",
  #     "sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
  #     "sudo chmod +x /usr/local/bin/docker-compose",
  #     "docker-compose --version"
  #     # Additional commands for Docker setup or container deployment can be added here
  #   ]
  # }

  # connection {
  #   type        = "ssh"
  #   user        = "ec2-user"                      # Replace with the username for your AMI
  #   private_key = tls_private_key.ssh_private_key.private_key_pem  # Use the private key directly
  #   host        = self.public_ip                 # You can use `self.public_dns` as well
  # }

  # provisioner "file" {
  #   source = "AuroPro_Project_3/entry-script.sh"
  #   destination = "/home/ec2-user/entry-script-on-ec2.sh"
  # }

  # provisioner "remote-exec" {
  #   script = file("AuroPro_Project_3/entry-script.sh")
  # }

}

# resource "aws_key_pair" "ssh_key" {
#   key_name   = "my-key-pair"
#   public_key = file("public_key.pub")  # Use the public key directly
# }

data "aws_ami" "latest-amazon-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "my_security_group" {
  name_prefix   = "${var.env_prefix}-security-group"
  description   = "Allow traffic on specified ports"
  vpc_id        = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }


  ingress {
    from_port   = 2375
    to_port     = 2375
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with the appropriate IP range for your MySQL server
  }

  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

  tags = {
    Name = "${var.env_prefix}-security-group"
  }
}
