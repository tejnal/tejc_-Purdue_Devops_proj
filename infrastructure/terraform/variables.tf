# var region
variable "aws_region" {
  default = "us-east-1"
}

# list port of SG
variable "ingressrules" {
  type    = list(number)
  default = [8080, 22]
}
# AMI EC2 Linux
variable "jenkins_ami" {
  default = "ami-026b57f3c383c2eec"
}
