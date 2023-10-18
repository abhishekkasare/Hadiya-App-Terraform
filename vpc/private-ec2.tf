resource "aws_instance" "ec2" {
  ami           = var.priv_instance_ami
  instance_type = var.priv_instance_type
  subnet_id = aws_subnet.subnet03.id
  
  tags = {
    Name = var.priv_instance_name
  }
}