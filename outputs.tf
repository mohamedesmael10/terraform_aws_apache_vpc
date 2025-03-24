output "public_apache_public_ip" {
  description = "Public IP of the Public Apache EC2 instance."
  value       = aws_instance.Esmael_apache_ec2_public.public_ip
}

output "public_apache_private_ip" {
  description = "Private IP of the Public Apache EC2 instance."
  value       = aws_instance.Esmael_apache_ec2_public.private_ip
}

output "private_apache_private_ip" {
  description = "Private IP of the Private Apache EC2 instance."
  value       = aws_instance.Esmael_apache_ec2_private.private_ip
}

output "elastic_ip" {
  description = "Elastic IP address associated with the NAT Gateway."
  value       = aws_eip.nat_eip.public_ip
}
