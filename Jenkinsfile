pipeline {
    agent any
    tools {
        terraform 'TERRAFORM_HOME'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'Prod-be', credentialsId: 'GitHUB', url: 'https://github.com/PrathamBaliTesting/terraform.git'
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
                    try {
                        input message: 'Do you want to proceed with Terraform destroy?', timeout: 1*60, timeoutMessage: 'Approval timed out. Aborting the build.'
                    } catch (err) {
                        error 'Terraform destroy was not approved in time.'
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