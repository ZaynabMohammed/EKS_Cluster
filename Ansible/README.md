# Configure BastionHost with Ansible  

We will execute several `Ansible-playbooks` to configure `jenkins` `Docker` `Kubectl` and `GIT` within the Bastion Host environment.  

<div style="display: flex; justify-content: space-between; align-items: center;">
  <img src="https://www.vectorlogo.zone/logos/ansible/ansible-ar21.svg"; alt="Ansible" width="110" height="130">
  <img src="https://www.vectorlogo.zone/logos/docker/docker-official.svg"; alt="Docker" width="100" height="100">
  <img src="https://www.vectorlogo.zone/logos/kubernetes/kubernetes-ar21.svg"; alt="Kubernetes" width="150" height="130">
  <img src="https://www.vectorlogo.zone/logos/amazon_aws/amazon_aws-ar21.svg"; alt="AWS" width="100" height="100">
  <img src="https://www.vectorlogo.zone/logos/jenkins/jenkins-ar21.svg"; alt="Jenkins" width="100" height="100">
</div>  

## Step 01: Connect to BastionHost
1. Get `instance_public_ip` from terraform output to add it in inventory && use `bastion_key.pem` to ssh into Ec2-Instance.
```bash
Bastion_Host ansible_host=instance_public_ip ansible_ssh_private_key_file=../EKS_terraform/bastion_key.pem
```
2. The `ansible.cfg` file is a configuration file for Ansible that allows you to customize various settings and behaviors of Ansible operations.
```bash
[defaults]
inventory = ./inventory
host_key_checking = False
remote_user = ec2-user
ask_pass = False

[privilege_escalation]
become=true
become_method=sudo
become_user=root
become_ask_pass=False
```
## Step 02: Configue Jenkins
1. RUN ansible `jenkins-playbook.yml` to configure Jenkins within the Bastion Host environment.
```bash
$ ansible-playbook jenkins-playbook.yml

PLAY [Setup Jenkins] **********************************************************************************************

TASK [Gathering Facts] ********************************************************************************************
ok: [Bastion_Host]

TASK [Download Jenkins repository file] ***************************************************************************
changed: [Bastion_Host]

TASK [Import Jenkins-CI key] ***************************************************************************************
changed: [Bastion_Host]

TASK [Install Java] *************************************************************************************************
changed: [Bastion_Host]

TASK [Install Jenkins] **********************************************************************************************
changed: [Bastion_Host]

TASK [Start Jenkins service] ****************************************************************************************
changed: [Bastion_Host]

TASK [Set Jenkins user shell to Bash] ********************************************************************************
changed: [Bastion_Host]

PLAY RECAP ************************************************************************************************************
Bastion_Host               : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
## Step 03: Configue Docker
1. RUN ansible `Docker-playbook.yml` to configure docker within the Bastion Host environment.
```bash
$ ansible-playbook Docker-playbook.yml

PLAY [Install Docker on Amazon Linux 2] **********************************************************************************

TASK [Gathering Facts] **************************************************************************************************
ok: [Bastion_Host]

TASK [Update the OS package index] **************************************************************************************
ok: [Bastion_Host]

TASK [Install required packages] ****************************************************************************************
changed: [Bastion_Host]

TASK [Add Docker repository] ********************************************************************************************
changed: [Bastion_Host]

TASK [Install Docker] ***************************************************************************************************
changed: [Bastion_Host]

TASK [Start and enable Docker service] **********************************************************************************
changed: [Bastion_Host]

TASK [Add ec2-user to the docker group] *********************************************************************************
changed: [Bastion_Host]

TASK [Add jenkins to the docker group] **********************************************************************************
changed: [Bastion_Host]

PLAY RECAP **************************************************************************************************************
Bastion_Host               : ok=8    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
## Step 04: Configue Kubectl and .kube/config
1. RUN ansible `Kubectl-playbook.yml` to configure kubectl command and EKS_Cluster_Context for jenkins user.
```bash
$ ansible-playbook Kubectl-playbook.yml

PLAY [Install kubectl&GIT] **************************************************************************************

TASK [Gathering Facts] ******************************************************************************************
ok: [Bastion_Host]

TASK [Download kubectl binary] **********************************************************************************
changed: [Bastion_Host]

TASK [Copy kubectl to /usr/local/bin] ***************************************************************************
changed: [Bastion_Host]

TASK [make kubectl executable] ***********************************************************************************
changed: [Bastion_Host]

TASK [Create .aws directory for jenkins user] *********************************************************************
changed: [Bastion_Host]

TASK [Copy AWS credentials to jenkins user home directory] *********************************************************
changed: [Bastion_Host]

TASK [Configure kubectl for Jenkins using AWS CLI] ******************************************************************
changed: [Bastion_Host]

TASK [Install GIT] **************************************************************************************************
changed: [Bastion_Host]

PLAY RECAP ***********************************************************************************************************
Bastion_Host               : ok=8    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
