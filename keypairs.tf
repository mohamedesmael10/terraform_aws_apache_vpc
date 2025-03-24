resource "tls_private_key" "esmael_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "esmael_keypair" {
  key_name   = "esmael_key"
  public_key = tls_private_key.esmael_key.public_key_openssh
}

resource "null_resource" "generate_key_file" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.esmael_key.private_key_pem}' > ~/.ssh/terraform.pem"
  }

  depends_on = [aws_key_pair.esmael_keypair]
}
