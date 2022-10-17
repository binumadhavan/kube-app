resource "aws_key_pair" "webserver_key" {
  public_key = file("web_key.pub")
  key_name   = "web_key"
}

resource "aws_instance" "webserver" {
  ami                    = var.ami_details[var.reg]
  instance_type          = var.instancetype
  vpc_security_group_ids = ["sg-0a68f6d36178bedd0"]
  key_name               = aws_key_pair.webserver_key.key_name

  tags = {
    owner = "Binu"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }


  connection {
    type        = "ssh"
    user        = var.user
    private_key = file("web_key")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh",
    ]
  }

  provisioner "local-exec" {
    command = "echo aws_instance.webserver.public_ip >> publicip.txt"
  }
}

output "ec2_publicip" {
  value = aws_instance.webserver.public_ip
}
output "ec2_privateip" {
  value = aws_instance.webserver.private_ip
}