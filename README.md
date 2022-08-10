# DevOpsProject

Hi everyone! hope you are doing well.
By using this repo you can deploy a k8s cluster from zero on AWS by using terraform, ansible, docker, k8s, kubeadm, fannel network, etc.
The k8s cluster contain one master node and two worker nodes.


*Before you are getting into it there is a few pre-steps:*

1) Install AWS CLI on your local machine and config you AWS keys. (this pre-step is maybe the most important because without it you can use the automation tools in a secure way).
2) install Terraform and Ansible on your local machine.
3) Enable Ansible aws_ec2 plugin ( sudo vi /etc/ansible/ansible.cfg --> under "[inventory]" add: enable_plugins = aws_ec2 ).
4) Terraform will install python3, pip, ansible and boto3 libary. The Ansible is installing by pip3 to avoid running the ansible by python 2.7 (because          boto3 not supported...) BUT make sure ansible is using python3 (check with: ansible --version).
5) Create a Docker image ( you can use a simple one from DockerHub or one of your self but you can try the one I used ).

*Work Flow:*

1) Clone this repo.
2) Start with Terraform.
3) Now you have the VPC for the cluster, with one ansible master in it.
4) Lets check the dynamic inventory before we starting to have fun by using: ansible-inventory -i <inventory_path>/aws_ec2.yaml --list
5) Run the ansible playbook.
6) Now you have a full configured K8S cluster with one master and two worker nodes.
7) Start deploy what ever you want to the cluster.

*Important to know*

You are using kubeadm (official project of k8s) to deploy the cluster.
There is alot to understand about it, also about the fannel network we are using but the most common "problem"
is the imagePullPolicy in kubeadm is set to Always so every node will try to pull the image everytime you are creating a deploy.
It has its advantages, but it is important to understand what it means to us, the DevOps Engineers.
It means that when it comes to local images that you build and tag you will need to create a private repo in DockerHub and connect it to the nodes because it will try to pull the image from some repo and not from the local images.

Hope you enjoy!
