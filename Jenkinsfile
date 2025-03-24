pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = 'docker-cred' 
        IMAGE_NAME = 'charan2135/my-coffee' 
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/ck2135/CoffeeProject.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    TAG = "v${BUILD_NUMBER}"
                    IMAGE_TAG = "${IMAGE_NAME}:${TAG}"
                    sh "docker build -t ${IMAGE_TAG} ."
                    sh "docker stop coffee && docker rm coffee"
                    sh "docker run -dit --name coffee -p 9001:80 ${IMAGE_TAG}"
                }
            }
        }
        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    }
                }
            }
        }
        stage('Push Image to Docker Hub') {
            steps {
                script {
                    sh "docker push ${IMAGE_TAG}"
                }
            }
        }
        stage('Cleanup') {
            steps {
                sh "docker rmi ${IMAGE_TAG}"
            }
        }
    }
}
