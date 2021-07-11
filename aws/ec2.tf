
#EC2 INSTANCE TO SPIN UP JENKINS AUTOMATION SERVER 
#NB: Create an ssh key in aws/ec2.tf and call it mykey
#ssh-keygen -f mykey


#Key pair 
resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)

}

#Elastic Network Interface 
resource "aws_network_interface"  "uclib_interface" {
  subnet_id        =  aws_subnet.app_public_subnets[0].id  #var.public_subnet_id

  tags =  {

    Name = var.name
  }

}

#EC2 Instance 
resource "aws_instance" "app_server" {
  count                    = var.create ? 1:0
  ami                      = var.ami_id 
  instance_type            = "t2.micro" 
  key_name                 = aws_key_pair.mykeypair.key_name
  vpc_security_group_ids   = [  aws_security_group.app_security_group.id  ]          #[ "sg-09fa14dc3ccbc786b" ]
  subnet_id                = aws_subnet.app_public_subnets[0].id   
  user_data                = file("userdata.sh")
  lifecycle {
    create_before_destroy  = true
  }
  tags = {
    Name = var.instance_tag
  }

}

#Elastic ip 
resource "aws_eip" "ip"{
  instance = aws_instance.app_server[0].id
  vpc      = true 

  tags     = {
    Name = "app_server_eip"
  }

}
