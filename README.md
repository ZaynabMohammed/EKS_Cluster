# A CICD Project to deploy web-app in EKS-Cluster

## Step 01: Power on EKS-Cluster with Terraform
1. Navigate to `EKS_terraform` directory
2. Run below commands to build below architecture.
<img src="https://github.com/ZaynabMohammed/CI-CD-Project/blob/master/Jenkins/jenkins.PNG" width="900" height="620" > 
```bash
# Terraform Initialize
terraform init
# Terraform Validate
terraform validate
# Terraform Plan
terraform plan
# Terraform Apply
terraform apply
```
## Step 01: Configure Bastion-Host with Ansible
1. Navigate to `Ansible` directory
2. SSH to EC2-Bastion-Host.
3. Run all ansible playbooks to configure `jenkins` `docker` `kubectl` `GIT` in EC2-Bastion-Host.
```bash
ansible-playbook jenkins-playbook.yml
ansible-playbook Docker-playbook.yml
ansible-playbook Kubectl-playbook.yml
```
## Step 03: Access Jenkins through browser:  
1. In the browser's address bar, enter `http://Bastion_Host_Public_IPv4_address:8080` and press Enter.
<img src="https://github.com/ZaynabMohammed/CI-CD-Project/blob/master/Jenkins/jenkins.PNG" width="900" height="620" >
2. Add `DockerHub` credantials.
   - Navigate to `Manage Jenkins`, Click on the `Credentials` under Secuirty section.
   - Click on the `Add Credentials` with Kind `Username with password` For basic authentication.
<img src="https://github.com/ZaynabMohammed/CI-CD-Project/blob/master/Jenkins/jenkins.PNG" width="900" height="620" >
3. Install docker plugin and Kubernetes plugin
   - Navigate to `Manage Jenkins`, Click on the `Plugins` in System Configuration section.
   - Click on the `available plugins` and install required plugins.

## Step 04: Create a pipeline Job to apply this jenkins_file to deploy web-app in EKS_Cluster.
### pipline Stages:
1. stage('Git') to use this Repository [Book-Node-Js](https://github.com/AlaaOrabi/Book-Node-Js.git)
2. stage('CI') to build dockerfile and push image to DockerHub.
3. stage('CD') to deploy web-app in EKS-Cluster
<img src="https://github.com/ZaynabMohammed/CI-CD-Project/blob/master/Jenkins/jenkins.PNG" width="900" height="620" >
```yaml
pipeline {
    agent any
    stages {
        stage('Git') {
            steps {
                git 'https://github.com/AlaaOrabi/Book-Node-Js.git';
            }
        }
        stage('CI') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                        docker build -t zeinab817/nodejs-app:v1 .
                        docker login -u ${USERNAME} -p ${PASSWORD}
                        docker image push zeinab817/nodejs-app:v1
                    '''
                }
            }
        }
        stage('CD') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                        docker login -u ${USERNAME} -p ${PASSWORD}
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                    '''
                }
            }
        }
    }
}
```
