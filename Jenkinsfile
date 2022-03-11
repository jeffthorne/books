pipeline{

    agent any

    stages {
        stage('Checkout'){
            steps{
                checkout scm
            }
        }


        stage('Build Docker Image'){
            steps{
                sh "docker build -t jeffthorne/books:latest ." 
            }
        }


        stage('Lacework Image Assurance Scan'){
            steps{
                script{
                    sh "ghost image --rego-file ${WORKSPACE}/ghost.rego --exit-code 2 --format template --template \"@${WORKSPACE}/lace.tpl\" -o /home/jeff/lw_data/lace.html --tags \"jenkins-build-${BUILD_NUMBER}\" jeffthorne/books:latest"
                }
            }
            
            post {
                always {
                    publishHTML target: [
                        allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: '/home/jeff/lw_data',
                        reportFiles: 'lace.html',
                        reportName: 'LaceScannerReport'
                        ]
                }
            }
        }

        stage('Push Docker Image to Registry'){
            steps{
                script{
                    sh "docker push jeffthorne/books:latest"
                }
            }
        }

        stage('Deploy to k8s'){
            steps{
                sh "kubectl  --kubeconfig=/home/jeff/config_element.yaml delete -f  ${WORKSPACE}/jeffsbooks-deployment.yaml -n jeffsbooks"
                sh "kubectl  --kubeconfig=/home/jeff/config_element.yaml apply -f ${WORKSPACE}/jeffsbooks-deployment.yaml -n jeffsbooks"

                }
        }
    }

}