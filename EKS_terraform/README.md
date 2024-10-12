# EKS_Cluster with Terraform
## Step 01: Generic-Vars & Provider
1. `c1_generic_vars` to identify AWS-Region `us-east-1`
2. `c1_provider.tf` to identify provider `AWS` and its version `>= 5.31`

## Step 02: VPC-module - Hardcoded Model
1. `c2_vpc_module.tf ` to use a [VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) from Terraform Public Registry.  
```
   ## Including below ##
   1. VPC Basic Details: [Public & Private subnets, AZs, CIDR]
   2. NAT Gateway,
   3. VPC DNS Parameters,
   4. Tags to Subnets
```
2. `c2_vpc_vars.tf` to define vars to vpc,using [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)  
```
   ## VPC-Vars ##
   1. vpc_name
   2. vpc_cidr_block
   3. vpc_availability_zones
   4. vpc_public_subnets, vpc_private_subnets
   5. vpc_enable_nat_gateway
   6. vpc_single_nat_gateway
```
3. `c2_vpc_outputs.tf` to display and retrive key data, which help in passing information between modules, using [Output Values](https://developer.hashicorp.com/terraform/language/values/outputs)   
  ```
  ## OUTPUTS ##
  1. VPC ID
  2. VPC CIDR block
  3. VPC Private Subnets
  4. VPC Public Subnets
  5. VPC NAT gateway Public IP
  6. VPC AZs
   ```  
## Step 03: EC2-BastionHost
1. `c3_EC2_bastion_instance.tf` using [AWS EC2 Instance Terraform Module](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)
2. `c3_EC2_bastion_EIP.tf` using [Terraform Resource AWS EC2 Elastic IP](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)
3. `c3_EC2_bastion_vars.tf` using [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)  
```
   ## EC2_bastion_vars ##
   1. AWS EC2 Instance Type
   2. AMI for EC2
```
4. `c3_EC2_bastion_SG.tf` using [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)  
   ```
   - Inbound rules:
    1. SSH: 22
    2. HTTP: 80
    3. Custom rule: 8080 ----> for jenkins
   ```
5. `c3_EC2_bastion_keypair.tf` using [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key), [aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)
6. `c3_EC2_bastion_provisioners.tf` using [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) to to connect to EC2 Bastionhost.    
    1. [File Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/file) to Copy the bastion_key.pem file to ~/bastion_key.pem
    2. [Remote Exec Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec) to fix the private key permissions on Bastion Host
    3. [Local Exec Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)  for (Creation-Time Provisioner - Triggered during Create Resource)
7. `c3_EC2_bastion_outputs.tf` using [Output Values](https://developer.hashicorp.com/terraform/language/values/outputs)
8. `c3_EC2_iamrole.tf` using [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role), [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)
```
   - Attatched Policies:
   1. AmazonEKSWorkerNodePolicy
   2. AmazonEC2ContainerRegistryReadOnly
   3. AmazonEKSClusterPolicy
```
## Step 04: EKS_Cluster && Node-Group
### EKS-Cluster
1. `c4_eks_cluster.tf` to [Create EKS Cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster)
2. `c4_iamrole_for_eks_cluster.tf` using [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role), [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)
```
   - Attatched Policies:
   1. AmazonEKSClusterPolicy
```
3. `c4_eks_vars.tf` using [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)  
```
    ## EKS-Vars ##
   1. cluster_name  
   2. cluster_service_ipv4_cidr  
   3. cluster_version  
   4. cluster_endpoint_private_access  
   5. cluster_endpoint_public_access  
   6. cluster_endpoint_public_access_cidrs  
```
 ### Node-GRP
 1. `c4_eks_node_grp_private.tf` using [aws_eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group)
 2. `c4_iamrole_for_node_grp.tf` using [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role), [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)
```
   - Attatched Policies:
   1. AmazonEKSWorkerNodePolicy
   2. AmazonEC2ContainerRegistryReadOnly
   3. AmazonEKS_CNI_Policy
```
3. `c4_eks_outputs.tf` using [Output Values](https://developer.hashicorp.com/terraform/language/values/outputs)  
  ```
## OUTPUTS ##
  1. cluster_id
  2. cluster_arn
  3. cluster_endpoint
  4. cluster_version
  5. node_group_private_id
  6. node_group_private_arn
```
