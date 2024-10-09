# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"  

  name = "EC2-BastionHost"
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.bastion_key_pair.key_name
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = aws_security_group.ec2_bastion_SG.name
  iam_instance_profile   = aws_iam_instance_profile.ec2_bastion_profile.name  

}
