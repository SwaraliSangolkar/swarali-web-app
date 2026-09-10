pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '160932097162.dkr.ecr.us-east-1.amazonaws.com/swarali-web-app'
        IMAGE_TAG = 'latest'
        CLUSTER = 'swarali-cluster'
        SERVICE = 'swarali-task-service'
    }

    stages {

        stage('Clone Code') {
    steps {
        git branch: 'main', url: 'https://github.com/SwaraliSangolkar/swarali-web-app.git'
    }
}

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t swarali-web-app .'
            }
        }

        stage('Login to ECR') {
            steps {
                bat '''
                aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin 160932097162.dkr.ecr.us-east-1.amazonaws.com
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                bat '''
                docker tag swarali-web-app:latest %ECR_REPO%:%IMAGE_TAG%
                docker push %ECR_REPO%:%IMAGE_TAG%
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                bat '''
                aws ecs update-service ^
                --cluster %CLUSTER% ^
                --service %SERVICE% ^
                --force-new-deployment
                '''
            }
        }
    }
}
