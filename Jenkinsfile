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
                    withCredentials([string(credentialsId: 'nexus-pswd', variable: 'nexus-pswd')]) {
                    sh '''
                    sudo docker build -t 184.73.41.229:8083/springapp:${BUILD_ID} .
                    echo ${nexus-pswd}
                    sudo docker login -u admin -p $nexus-pswd 184.73.41.229:8083
                    sudo docker push 184.73.41.229:8083/springapp:${BUILD_ID}
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