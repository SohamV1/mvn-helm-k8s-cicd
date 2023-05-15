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
                     sudo docker build -t 34.207.106.193:8083/springapp:${BUILD_ID} .
                     sudo docker login -u admin -p ${nexus} 34.207.106.193:8083
                     #sudo docker push 34.207.106.193:8083/springapp:${BUILD_ID}
                    '''
                   }
                }
            }
        }
    }
    post{
        always{
            echo "========always========"
        }
    }
}