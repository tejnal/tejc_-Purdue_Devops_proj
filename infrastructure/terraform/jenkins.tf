resource "aws_instance" "jenkins-server" {
  ami             = var.jenkins_ami
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.jenkins_traffic.name]
  key_name        = "edureka-devops"

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install java-openjdk11 -y",
      "sudo yum -y install wget",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum upgrade -y",
      "sudo yum install git -y",
      "sudo yum install maven -y",
      "sudo yum install jenkins -y",
      "sudo systemjava --versionctl enable jenkins",
      "sudo systemctl start jenkins",
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("key/edureka-devops.pem")
  }
  tags = {
    "Name" = "Jenkins"
  }
}

# 61653556e8e842b5ab98916dfb2e680d
