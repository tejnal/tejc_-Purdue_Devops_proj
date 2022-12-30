# Tej_Industry_Grade_Project1

# abctechnologies code
"#assignment1"

## Task1: Clone the project from the GitHub link shared in resources to your local machine. Build the code using Maven commands.
### Steps
- Build the application: `mvn clean test`
- Commit code to personal github account [Purdue industry_Grade_Project](https://github.com/tejnal/tejc_-Purdue_Devops_proj.git)

## Task 2: Set up the Git repository and push the source code.Then, log into Jenkins.
 1. Create a build pipeline containing a job for each
    - One for compiling source code
    - Second for testing source code
    - Third for packing the code
 2. Execute the CI/CD pipeline to execute the jobs created in step1
 3. Set up a master-slave node to distribute the tasks in the pipeline.

### Steps
- Using `Terraform` create AWS EC2 instance and install following tools and technologies 
**Java**
**Git**
**Maven** 
**Jenkins**

- You can find terraform related files in the  `tejc_-Purdue_Devops_proj/infrastructure` folder, once you ready with all the information you need to run
  `terraform plan`
  `terraform apply`
- login in two AWS instance check your jenkins server

![](../../Jenkins_server.png)

- Launch your aws instance run the following command
  `sudo systemctl start jenkins`
- Now open your favourite browser enter the below Ip address with port, unlock jenkins using admin password and install all the required softwares 
  `http://<jenkins_public_ip>:8080/login`
![](../../Purdue Project/Screenshot 2022-12-15 at 20.23.27.png)

- Create a build pipeline with following stages using script below
**Compile**
**Test**
**Packing*

```
pipeline {

    agent {label 'jenkins_slave'}

stages{

       stage('CloneRepo')
       {
           steps{
              git branch: 'main',  url: 'https://github.com/tejnal/tejc_-Purdue_Devops_proj.git'
 
           }
       }
       
       stage('Compile')
       {
           steps{
               sh  'mvn compile'
               
           }
       }
       
    
       stage('UnitTesting')
       {
           steps{
               sh 'mvn test'
           }
           post{
               success{
                   junit 'target/surefire-reports/*.xml'
               }
           }
       }
       
       
       stage('package')
       {
           steps{
               sh 'mvn package'
           }
       }
}

}
```

![](../../Purdue Project/CI-pipeline.png)

- Setup master slave node to distribute tasks
**Jenkins Master** is the primary Jenkins server and is responsible for the following tasks:

  - It distributes the builds among the numerous slaves for execution.
  - It organises the build projects.
  - It keeps an eye on the slaves at all times.  
  - Master can also run build jobs directly if necessary.
  - It keeps track of the build outcomes and shows them.

**Jenkins Slave** runs on a remote machine. A slave is responsible for the following tasks:

  - Slaves can be operated on a number of different operating systems. 
  - It responds to the Jenkins Master's demands. 
  - Apart from the fact that Jenkins executes the build task on the next available save, 
  - We can always arrange the project to run on a certain sort of slave computer. 
  - It also completes construction operations that the Master has dispatched.

  1) Crete `jenkins_slave` node on aws 
  2) Install java on slave node 
  3) create user and ssh key on slave node
     `[root@jenkins-slave1 ~]# useradd tejnal`
  4) Generate ssh-key for user tejnal and note down private key - to be added in Jenkins credentials

   ```
    [tejnal@jenkins-slave ~]$ ssh-keygen -t rsa
    [tejnal@jenkins-slave ~]$ cd .ssh/
    [tejnal@jenkins-slave ~]$ cat id_rsa.pub > authorized_keys
    [tejnal@jenkins-slave ~]$ chmod 700 authorized_keys
    [tejnal@jenkins-slave ~]$ cat authorized_keys
   ```
   5) On master - copy public key in /var/lib/jenkins/.ssh/known_hosts - used when selecting option Know hosts key strategy
   ```
    [root@jenkins-master ~]# mkdir /var/lib/jenkins/.ss
    [root@jenkins-master ~]# chown jenkins:jenkins /var/lib/jenkins/.ssh
    [root@jenkins-master ~]# echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2djObC0ahzBSVDKy82N4G/+orCAqwspGcPBZne0HL1f9S3ZJxZm+UJtCbbL0MjeXmJOJ3y1qRxn5f2e9+RLXADT7RDiGU1DOp3ZEqjETPHHZrM3fJEeu/kada7ivUoj3o82Uid7cBeAUtEUJ2L4uWPjdskjtOVi6AIpe/XTHr+uQ6zprqZovpeRJjJNeDyT4hXzH0587kCPyYxVSGkz5n2+/c2WV8QTrSiEb9fENiOE231AoRc38uN1f/eoernJ6lqO8PFLoOTp0qhcmOLa3Op1OJqikNa09yIfLZ1/CzAjJC8p19YiWei50ypmm0zcNrmxdtguOU1hKS0ie0UGLXpMhbsBI2YA6dXosTqCzQzB9PmOa+nLrwu6iFE34PN5UsvnmqQvhAWVsNLFzg+Uqok8fSd6pqxgvgNmYU4TSQJa+/K09DCj+xdAszOvWyuGRs6D3oSogvH0cjPa5qqXoMSecK/81NU44i37Mj6/cY5Q2AHj/LFKJEbvST9dSoPmU= prayag@jenkins-slave.example.com" > /var/lib/jenkins/.ssh/known_hosts
    [root@jenkins-master ~]# cat /var/lib/jenkins/.ssh/known_hosts
               ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2djObC0ahzBSVDKy82N4G/+orCAqwspGcPBZne0HL1f9S3ZJxZm+UJtCbbL0MjeXmJOJ3y1qRxn5f2e9+RLXADT7RDiGU1DOp3ZEqjETPHHZrM3fJEeu/kada7ivUoj3o82Uid7cBeAUtEUJ2L4uWPjdskjtOVi6AIpe/XTHr+uQ6zprqZovpeRJjJNeDyT4hXzH0587kCPyYxVSGkz5n2+/c2WV8QTrSiEb9fENiOE231AoRc38uN1f/eoernJ6lqO8PFLoOTp0qhcmOLa3Op1OJqikNa09yIfLZ1/CzAjJC8p19YiWei50ypmm0zcNrmxdtguOU1hKS0ie0UGLXpMhbsBI2YA6dXosTqCzQzB9PmOa+nLrwu6iFE34PN5UsvnmqQvhAWVsNLFzg+Uqok8fSd6pqxgvgNmYU4TSQJa+/K09DCj+xdAszOvWyuGRs6D3oSogvH0cjPa5qqXoMSecK/81NU44i37Mj6/cY5Q2AHj/LFKJEbvST9dSoPmU= tejnal@jenkins-slave.example.com
    [root@jenkins-master ~]# ssh-keyscan -H jenkins-slave.example.com >>/var/lib/jenkins/.ssh/known_hostsh
   ```
   6) Create new Jenkins slave by entering values
       `Dashboards ->> Manage Jenkins ->> Mange Nodes ans clouds ->> New Node`
    **Name**
    **Number of executors**
    **Remote root directory**
    **Launch method**
    **Tools locations**

   ![](../../Purdue Project/Screenshot 2022-12-15 at 21.41.43.png)
    
  **Create Credentials**
   ![](../../Purdue Project/Screenshot 2022-12-15 at 21.42.44.png)

   ![](../../Purdue Project/Screenshot 2022-12-15 at 21.47.08.png)

   7) Re run CI-pipeline it will run on **Jenkinslave1**
     ![](../../Purdue Project/Screenshot 2022-12-15 at 21.50.26.png)

## Task 3:  Write a Docket file.Create an Image and container on the Docker host. Integrate docker host with Jenkins. Create CI/CD job on Jenkins to build and deploy on a container.
   1. Enhance the package job created in step 1 of task 2 to create a docker image.
   2. In the Docker image,add code to move the war file to the Tomcat server and build the image

### Steps
- Create dockerfile to move war file the tomcat server 

  ```
   FROM tomcat:8.0-alpine
   LABEL maintainer = "tejnal@edureka.com"
   ADD ./target/ABCtechnologies-1.0.war /usr/local/tomcat/webapps
   CMD ["catalina.sh", "run"]
   EXPOSE 8080
  ```
- Create CI pipeline to **build docker image** and **push docker image to dockerhub**
  ```
  pipeline {
      agent any
      environment {
          imageName = 'tejnal/edurekaapp'
          registryCredential = 'tejnal-dockerhub'
          dockerImage = ''
          repoUrl = 'https://github.com/tejnal/tejc_-Purdue_Devops_proj.git'
      }
      stages {
          stage('Git project checkout') {
             steps {
                 git branch: 'main', url: 'https://github.com/tejnal/tejc_-Purdue_Devops_proj.git'
             }
          }
          stage('Compile') {
            steps {
                sh  'mvn compile'
            }
          }
          stage('UnitTesting') {
            steps{
                sh 'mvn test'
            }
            post{
                success{
                    junit 'target/surefire-reports/*.xml'
                }
            }
          }

        stage('Build Application') {
            steps {
                sh 'mvn clean install'
            }
            post {
                success {
                    echo "Now Archiving the Artifacts...."
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }


        stage('Building image') {
            steps{
                sh 'docker build -t tejnal/edurekaapp:latest .'
            }
        }

        stage('Deploy Image') {
            steps{
                sh 'docker login -u "tejnal" -p "xxxxxxx" docker.io'
                sh 'docker push tejnal/edurekaapp:latest'
            }
        }
      }
  }
  ```
![](../../Purdue Project/docker_image.png)

## Task4: Integrate the Docker host with Ansible. Write an Ansible playbook to create an image and create a continuer. Integrate Ansible with Jenkins. Deploy Ansible-playbook. CI/CD job to build code on ansible and deploy it on docker container
  1. Deploy Artifacts on Kubernetes
  2. Write pod, service, and deployment manifest file
  3. Integrate Kubernetes with Ansible
  4. Ansible playbook to create deployment and service

- Integrate dockerhost  with ansible
  - on dockerhost 
    * Create ansadmin `useradd ansadmin`
    * Add ansadmin to sudoers files 
    * Enable password based login 
  
  - on ansible node 
    * add to host files `vim /etc/ansible/hosts`
    * copy ssh keys `ssh-copy-id <docker private ip>`
    * Test connection `ansible all -m ping`
    
- Integrate Ansible with jenkins
    * login jenkins go to  `manage jenkins -> configure system -> SSH servers`
    * configure docker server and ansible server 
    ![](../../Purdue Project/ansible_server.png)
    ![](../../Purdue Project/docker_server.png)
  
    * Create new build pipeline `Build_copy_artifact_docker_host`
    * Send build artifacts over SSH server 
    ![](../../Purdue Project/Build_artificats_over_ssh_server.png)

- Ansible playbook to create image and container 
    * Write an ansible playbook on ansible host and push image to dockerhub registry 
    ![](../../Purdue Project/Ansible_playbook.png)
    ![](../../Purdue Project/dockerhub_registry.png)

- Create jenkins job to build an image onto Ansible 
    * Create a build pipeline job `Copy_Artifacts_to_Ansible`
    ![](../../Purdue Project/Copy_Artifacts_toAnsible.png)

- Continuous deployment of docker container using ansible playbook 
    * pull image from docker hub and run that image on docker host using ansible playbook 
    ![](../../Purdue Project/deploy_adbtechapp.png)

- Set up AWS EKS cluster 
    * Create new aws ec2 instance 
    * install `kubectl` `ekscrtl` following [aws installation guide](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)
    * create IAM role `eksctl`
    * Assign IAM role to k8s  server 
    * Create cluster `eksctl-tej-devops-purdue-cluster`

      `eksctl create cluster --name tej-devops-purdue \
      --region us-south-1 \
      --node-type t2.small \`

    ![](../../Purdue Project/edudevop_cluster.png)
    
     * Create kubernates 
https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/ [ pod]
     * https://kubernetes.io/docs/concepts/services-networking/service/ [ service]

- integrate kubernetes with ansible 
    - On aws eks server 
      * crate ansadmin 
      * add ansadmin to sudoers files 
      * enable password based login 
    
    - On ansible server 
      * Add to hosts file 
      * Copy ssh keys 
      * Test the connection

- Create ansible playbook for deploy and service files
    - on ansible server 
     * create kube_deploy.yml file and run `ansible-playbook -i /opt/docker/hosts kube_deploy.yml`
       ![](../../Purdue Project/kube-deploy.png)
     
     * create kube_service.yml and run `ansible-playbook -i /opt/docker/hosts kube_service.yml`
      ![](../../Purdue Project/kube-service.png)

- Create Jenkins deployment  job for kubernetes
    - on jenkins server 
     * Create new jenkins job `Deploy_On_Kubernetes`
      ![](../../Purdue Project/jenkins_k8s.png)
    


## Task 5

- Setup `Prometheus` and `Grafana` on aws eks cluster
    - Prerequisites
        * Install aws cli 
        * Install helm 
        * Install kubectl 
    - create namespace for Prometheus and Grafana
    ![](../../Screenshot 2022-12-30 at 08.25.35.png)
    - Install required Helm repositories
         * `$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`
         * `$ helm repo add grafana https://grafana.github.io/helm-charts`
    - Install Prometheus
        * `$ helm install prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2" --set server.persistentVolume.storageClass="gp2"`
    - Install Grafana
        * `$ helm install grafana grafana/grafana --namespace grafana --set persistence.storageClassName="gp2" --set persistence.enabled=true --set adminPassword='EKS' --values ./grafana.yaml --set service.type=LoadBalancer`
    - Access Prometheus UI 
        * `kubectl port-forward -n prometheus deploy/prometheus-server 8080:9090`
        ![](../../Screenshot 2022-12-30 at 08.43.18.png)
    - Access Grafana UI
        ![](../../Screenshot 2022-12-30 at 08.44.08.png)
    - Network I/O, Cluster Memory Usage Cluster CPU usage
        ![](../../Screenshot 2022-12-30 at 08.45.00.png)
        ![](../../Screenshot 2022-12-30 at 08.45.09.png)
        ![](../../Screenshot 2022-12-30 at 08.45.25.png)

      
 
  
  





















