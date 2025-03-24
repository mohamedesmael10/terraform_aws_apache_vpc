region               = "us-east-1"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24"]
private_subnet_cidrs = ["10.0.2.0/24"]
subnet_name          = ["Esmael_public-subnet", "Esmael_public-subnet2", "Esmael_private-subnet", "Esmael_private-subnet2"]
aws_ami              = "ami-04b4f1a9cf54c11d0"  
instance_type        = "t2.micro"
