pipeline{
    agent any
    stages{
        stage ("Git Checkout"){
            steps{
                script{
                    git 'https://github.com/SohamV1/mvn-helm-k8s-cicd.git'
                }
            }
        }
        stage("mvn unit and integration tests"){
            steps{
                script{
                sh '''
                mvn test
                mvn verify -DskipUnitTests
                '''
              }
            }
        }
        stage('Build mvn project'){
            steps{
                script{
                 sh 'mvn clean install'
                }
            }
        }
        stage("Static Code Analysis"){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonarqube') {
                      sh 'mvn clean package sonar:sonar'
                    }
                }
            }
        }
        stage("Create Docker file"){
            steps{
                script{
                   withCredentials([string(credentialsId: 'nexus', variable: 'nexus')]) {
                    sh '''
                     sudo docker build -t 18.204.195.185:8083/springapp:${BUILD_ID} .
                     sudo docker login -u admin -p ${nexus} 18.204.195.185:8083
                     sudo docker push 18.204.195.185:8083/springapp:${BUILD_ID}
                    '''
                   }
                }
            }
        }
        stage("Identifying misconfigs using datree "){
            steps{
                script{
                    dir('kubernetes/myapp/') {
                       withEnv(['DATREE_TOKEN=51349fd1-08fb-479c-a0aa-b37264f98c75']) {
                         sh ' helm datree test . '
                       }
                    }
                }
            }
        }
        stage("Upload to helm repo"){
            steps{
                script{
                   withCredentials([string(credentialsId: 'nexus', variable: 'nexus')]) {
                    dir('kubernetes/myapp/') {
                      sh '''
                      helm package .
                      helmversion=$(helm show chart . | grep version | cut -d" " -f 2)
                      curl -u admin:$nexus http://18.204.195.185:8081/repository/helm-repo/ --upload-file myapp-${helmversion}.tgz  -v 
                      rm -rf myapp-${helmversion}.tgz
                      '''
                    }
                    }
                }
            } 
        }
    }
    post {
		always {
			mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "sohamv000@gmail.com";  
		}
	}
}