pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
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
    sh """
        terraform init
        terraform plan -var='region=${AWS_REGION}'
        terraform apply -auto-approve -var='region=${AWS_REGION}'
    """
}
