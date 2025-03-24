variable "region" {
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}

variable "aws_ami" {
  type        = string
  default     = "ami-04b4f1a9cf54c11d0"
}

variable "subnet_name" {
  type        = list(string)
  default     = ["Esmael_public-subnet", "Esmael_public-subnet2", "Esmael_private-subnet", "Esmael_private-subnet2"]
}
