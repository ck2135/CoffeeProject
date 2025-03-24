pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = 'docker-cred' 
        SONARQUBE_CREDENTIALS_ID = 'sonarqube' // Defined SonarQube credentials ID
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
                    def TAG = "v${BUILD_NUMBER}"
                    def IMAGE_TAG = "${IMAGE_NAME}:${TAG}"

                    // Stop and remove any existing 'coffee' container
                    sh "docker stop coffee || true"
                    sh "docker rm coffee || true"

                    // Remove old images (except the latest one)
                    sh """
                    docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | grep '${IMAGE_NAME}:' | sort -r | tail -n +2 | awk '{print \$2}' | xargs -r docker rmi -f || true
                    """

                    // Build and run the new container
                    sh "docker build -t ${IMAGE_TAG} ."
                    sh "docker run -dit --name coffee -p 8001:80 ${IMAGE_TAG}"
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    withCredentials([string(credentialsId: SONARQUBE_CREDENTIALS_ID, variable: 'SONAR_TOKEN')]) {
                        sh """
                        sonar-scanner \
                          -Dsonar.projectKey=coffee \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=http://13.233.200.63:9000/ \
                          -Dsonar.login=${SONAR_TOKEN}
                        """
                    }
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
                    def TAG = "v${BUILD_NUMBER}"
                    def IMAGE_TAG = "${IMAGE_NAME}:${TAG}"
                    sh "docker push ${IMAGE_TAG}"
                }
            }
        }
    }
}
