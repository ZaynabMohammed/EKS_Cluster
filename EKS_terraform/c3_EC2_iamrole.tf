# IAM Role for EC2_Bastion_Host 
resource "aws_iam_role" "ec2_bastion_role" {
  name = "ec2_bastion_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "ec2-EKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ec2_bastion_role.name
}

resource "aws_iam_role_policy_attachment" "ec2-EKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ec2_bastion_role.name
}

 resource "aws_iam_role_policy_attachment" "ec2-EC2ContainerRegistryReadOnly" {
   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
   role       = aws_iam_role.ec2_bastion_role.name
 }


resource "aws_iam_instance_profile" "ec2_bastion_profile" {
  name = "ec2_bastion_profile"
  role = aws_iam_role.ec2_bastion_role.name


}
