# EC2 Resource

//region MAIN EC2 Resource
resource "aws_instance" "ec2_instance" {
  ami           = var.ec2_image
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_keypair
  count         = var.ec2_count
  security_groups = [
    aws_security_group.EC2_SecurityGroup.id]
  tags          = {
    Name = var.project_name
  }
}
//endregion

##Security Group resource for EC2

resource "aws_security_group" "EC2_SecurityGroup" {
  name        = var.ec2_SecurityGroup
  description = var.SG_Description
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" ##Outbound to all
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "MAP3_SecurityGroup"
  }
}
