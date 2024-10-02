resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_key_pair" {
  key_name = "EC2_Key"
  public_key = tls_private_key.bastion_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.bastion_key.private_key_pem}' > ./bastion_key.pem"
  }
}