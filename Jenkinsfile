pipeline {
    agent any
    environment {
        imageName = 'tejnal/edurekaapp'
        registryCredential = 'tejnal-dockerhub'
        dockerImage = ''
        repoUrl = 'https://github.com/tejnal0999/Tej_Industry_Grade_Project1.git'
    }
    stages {
	    stage('Git project checkout') {
           steps {
               git branch: 'main', url: 'https://github.com/tejnal0999/Tej_Industry_Grade_Project1.git'
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
                script {
                    dockerImage = docker.build imageName
                }
            }
        }
            stage('Running image') {
                steps{
                    script {
                        sh "docker run ${imageName}:latest"
                }
            }
        }

        stage('Deploy Image') {
            steps{
                script {
                     docker.withRegistry( '', registryCredential ) {
                         dockerImage.push("$BUILD_NUMBER")
                             dockerImage.push('latest')
                     sh """
                     git tag -a ${BUILD_NUMBER} -m "build number ${BUILD_NUMBER}"
                     git push ${repoUrl} ${BUILD_NUMBER}
                     """

                    }
                }
            }
        }
    }
}