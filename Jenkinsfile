pipeline {
    agent any

    environment {
        // Securely retrieve credentials from Jenkins Credential Store
        PROD_CREDS = credentials('prod-server-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Archive Artifact') {
            steps {
                // Archive the generated versioned JAR file
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                
                // Publish JUnit Test Results
                junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
            }
        }

        stage('Manual Approval') {
            when {
                branch 'main'
            }
            steps {
                script {
                    try {
                        // Request manual approval before production deployment
                        input message: 'Do you want to deploy this artifact to Production?', ok: 'Deploy'
                    } catch (err) {
                        // Mark as ABORTED instead of FAILURE if user rejects
                        currentBuild.result = 'ABORTED'
                        error("Deployment rejected by reviewer.")
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                // Secure credential handling without exposing secrets in logs
                withCredentials([usernamePassword(credentialsId: 'prod-server-credentials', passwordVariable: 'PROD_PASSWORD', usernameVariable: 'PROD_USER')]) {
                    script {
                        echo "Deploying artifact to Production Server..."
                        // Pass exact target file dynamically to deploy.sh
                        sh '''
                            JAR_FILE=$(ls target/*.jar | head -n 1)
                            echo "Deploying exact artifact: ${JAR_FILE}"
                            ./deploy.sh "${JAR_FILE}"
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Publishing test reports and cleaning workspace..."
            cleanWs()
        }
        success {
            echo "SUCCESS: Deployment completed successfully."
        }
        failure {
            echo "FAILURE: Pipeline execution failed."
        }
        aborted {
            echo "ABORTED: Deployment was rejected/cancelled by user."
        }
    }
}