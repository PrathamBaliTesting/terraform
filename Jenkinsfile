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

        stage('User Confirmation') {
            steps {
                script {
                    def userInput = input(
                        message: 'Do you want to destroy the resources in both environments?',
                        parameters: [
                            [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Select this to destroy the resources in both environments.', name: 'Destroy']
                        ]
                    )

                    if (userInput) {
                        echo 'User confirmed. Proceeding to destroy both environments...'
                        dir('development') {
                            script {
                                terraformAction('development', 'destroy')
                            }
                        }
                        dir('production') {
                            script {
                                terraformAction('production', 'destroy')
                            }
                        }
                    } else {
                        echo 'User chose not to destroy resources. Pipeline will end.'
                    }
                }
            }
        }
    }
}

def terraformAction(env, action = 'apply') {
    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_access_key']]) {
        bat """
            echo "Running Terraform ${action} for ${env} environment"
            terraform init
            terraform ${action} -var="availability_zone=us-east-1a"
        """
    }
}
