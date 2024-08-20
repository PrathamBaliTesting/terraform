pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
    }

    stages {
        stage('Run Terraform for Both Environments') {
            parallel {
                stage('Development') {
                    steps {
                        dir('development') {
                            script {
                                terraformAction('development')
                            }
                        }
                    }
                }
                stage('Production') {
                    steps {
                        dir('production') {
                            script {
                                terraformAction('production')
                            }
                        }
                    }
                }
            }
        }
    }
}

def terraformAction(env) {
    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_access_key']]) {
        bat """
            echo "Running Terraform for ${env} environment"
            terraform init
            terraform plan -var="availability_zone=${AWS_REGION}"
            terraform apply -auto-approve -var="availability_zone=${AWS_REGION}"
        """
    }
}
