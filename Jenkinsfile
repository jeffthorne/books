pipeline{


    agent { label 'master' }


    stages {
          stage('Checkout'){
            steps{
                checkout scm
            }
          }


          stage('Build Docker Image'){
            steps{
                sh "docker build -t jeffthorne/books:latest ."
                sh "sleep 4"
                sh "python3 /home/jeff/update_sha.py ${WORKSPACE}/jeffsbooks-deployment.yaml"
            }
        }


               stage('Lacework Image Assurance Scan'){
                   steps{
                        script{
                            sh "lw-scanner evaluate jeffthorne/books latest --data-directory /home/jeff/lw_data"
                            sh "/home/jeff/.local/bin/lwh opa --url https://192.168.1.192:8443 --input \$(ls -t /home/jeff/lw_data/evaluations/jeffthorne/books/latest  | awk '{printf(\"/home/jeff/lw_data/evaluations/jeffthorne/books/latest/%s\",\$0);exit}') --output /home/jeff/lw_data/lacework_imageassurance.html"
                            sh "sleep 10"

                        }
                    }
                     post {
                    always {
                        publishHTML target: [
                            allowMissing: false,
                            alwaysLinkToLastBuild: true,
                            keepAll: true,
                            reportDir: '/home/jeff/lw_data',
                            reportFiles: 'lacework_imageassurance.html',
                            reportName: 'LaceworkScannerReport'
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
                        sh "kubectl  delete -f  jeffsbooks-deployment.yaml -n jeffsbooks"
                        sh "kubectl  apply -f jeffsbooks-deployment.yaml -n jeffsbooks"

                     }
                }
    }

}