# AWS EC2 Instance Terraform Variables

# AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t3.medium"  
}

# AMI for EC2
variable "ami" {
  type    = string
  default = "ami-0fff1b9a61dec8a5f"
}
