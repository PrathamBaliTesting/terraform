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
    bat """
        terraform init
        terraform plan -var="availability_zone=us-east-1"
        terraform apply -auto-approve -var="availability_zone=us-east-1"
        """
}
