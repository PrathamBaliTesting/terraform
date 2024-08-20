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
                                terraformAction('development', 'apply')
                            }
                        }
                    }
                }
                stage('Production') {
                    steps {
                        dir('production') {
                            script {
                                terraformAction('production', 'apply')
                            }
                        }
                    }
                }
            }
        }
        stage('Approval and Destroy') {
            steps {
                script {
                    input message: 'Do you want to destroy all resources?', ok: 'Yes'
                }
            }
        }
        stage('Destroy Terraform for Both Environments') {
            parallel {
                stage('Development') {
                    steps {
                        dir('development') {
                            script {
                                terraformAction('development', 'destroy')
                            }
                        }
                    }
                }
                stage('Production') {
                    steps {
                        dir('production') {
                            script {
                                terraformAction('production', 'destroy')
                            }
                        }
                    }
                }
            }
        }
    }
}

def terraformAction(env, action) {
    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_access_key']]) {
        bat """
            echo Running Terraform ${action} for ${env} environment
            terraform init
            terraform plan -var="availability_zone=${AWS_REGION}" -out=tfplan
            if "%action%" == "apply" (
                terraform apply -auto-approve tfplan
            ) else (
                terraform destroy -auto-approve -var="availability_zone=${AWS_REGION}"
            )
        """
    }
}

