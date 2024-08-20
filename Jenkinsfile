pipeline {
    agent any
    tools {
        terraform 'TERRAFORM_HOME'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'DEV-BE', credentialsId: 'GitHUB', url: 'https://github.com/PrathamBaliTesting/terraform.git'
            }
        }
        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }
        stage('Terraform Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_access_key']]) {
                    bat 'terraform apply --auto-approve'
                }
            }
        }
        stage('Approve Destroy') {
            steps {
                  script {
                    timeout(time: 1, unit: 'MINUTES') {
                        input message: 'Do you want to proceed with Terraform destroy?'
                    }
                }
            }
        }
        stage('Destroy Infrastructure') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_access_key']]) {
                    bat 'terraform destroy --auto-approve'
                }
            }
        }
    }
}
