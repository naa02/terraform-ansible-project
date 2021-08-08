resource "aws_instance" "my_instance" {
  ami                    = "ami-05f375b54be4ab849"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_sg_web.id]
  key_name               = aws_key_pair.my_sshkey.key_name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./my_sshkey")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "site.yaml"
    destination = "/home/ubuntu/site.yaml"
  }

  provisioner "file" {
    source      = "roles"
    destination = "/home/ubuntu"
  }

  provisioner "file" {
    source      = "group_vars"
    destination = "/home/ubuntu/"
  }

  # provisioner "remote-exec" {
  #    inline = [
  #      "echo 'ssh connected!!!'",
  #    ]
  #  }

  provisioner "local-exec" {
    command = <<-EOF
        ssh-keyscan -t ssh-rsa ${self.public_ip}} >> .ssh/known_hosts
        echo "${self.public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=./my_sshkey" > inventory.ini
	echo "private_ip: ${self.private_ip}" >> group_vars/all.yaml
	echo "service_port: ${var.wp_port}" >> group_vars/all.yaml
	sudo apt-get update
        EOF
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini site.yaml -b"
  }

  tags = local.common_tags
}

resource "aws_key_pair" "my_sshkey" {
  key_name   = "my_sshkey"
  public_key = file("./my_sshkey.pub")
}
