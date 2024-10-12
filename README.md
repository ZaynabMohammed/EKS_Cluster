# A CICD Project to deploy web-app in EKS-Cluster

## Step 01: Power on EKS-Cluster with Terraform
1. Navigate to `EKS_terraform` directory
2. Run below commands to build below architecture.
   
<img src="https://github.com/ZaynabMohammed/EKS_Cluster/blob/master/images/EKS-Arch%20.PNG" width="900" height="620" >

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
   
<img src="https://github.com/ZaynabMohammed/EKS_Cluster/blob/master/images/jenkins.PNG" width="900" height="620" >  

2. Add `DockerHub` credantials.
   - Navigate to `Manage Jenkins`, Click on the `Credentials` under Secuirty section.
   - Click on the `Add Credentials` with Kind `Username with password` For basic authentication.  

<img src="https://github.com/ZaynabMohammed/EKS_Cluster/blob/master/images/add-cred.PNG" width="900" height="620" >  

3. Install docker plugin and Kubernetes plugin
   - Navigate to `Manage Jenkins`, Click on the `Plugins` in System Configuration section.
   - Click on the `available plugins` and install required plugins.

## Step 04: Create a pipeline Job to apply this jenkins_file to deploy web-app in EKS_Cluster.
### pipline Stages:
1. stage('Git') to use this Repository [Book-Node-Js](https://github.com/AlaaOrabi/Book-Node-Js.git)
2. stage('CI') to build dockerfile and push image to DockerHub.
3. stage('CD') to deploy web-app in EKS-Cluster  
  
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

## Step 05: Hit Book CRUD Application 
1. SSH to EC2-Bastion-Host.
```bash
ssh -i bastion_key.pem ec2-user@'Bastion_Host_Public_IPv4_address'
```
2. Switch to jenkins user
```bash
su jenkins
```
3. RUN Kubectl get all to get `EXTERNAL-IP` 
```bash
bash-5.2$ kubectl get all
NAME                                    READY   STATUS    RESTARTS   AGE
pod/book-node-js-6db5756568-2b8r6       1/1     Running   0          2m56s
pod/book-node-js-6db5756568-7g4j7       1/1     Running   0          2m56s
pod/book-node-js-6db5756568-mh27s       1/1     Running   0          2m56s

NAME                           TYPE           CLUSTER-IP      EXTERNAL-IP                                                               PORT(S)          AGE
service/book-node-js-service   LoadBalancer   172.20.169.38   a9531a81190ba44b8a86f63feb7d2176-1948262158.us-east-1.elb.amazonaws.com   3000:30001/TCP   2m55s
service/kubernetes             ClusterIP      172.20.0.1      <none>                                                                    443/TCP          6h35m

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/book-node-js       3/3     3            3           2m56s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/book-node-js-6db5756568       3         3         3       2m56s
```
4. In the browser's address bar, enter `EXTERNAL-IP:3000` and press Enter.  

<img src="https://github.com/ZaynabMohammed/EKS_Cluster/blob/master/images/book-app.PNG" width="900" height="620" >   
