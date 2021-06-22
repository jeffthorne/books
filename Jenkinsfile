pipeline{


    agent { label 'node1' }


    stages {
          stage('Checkout'){
            steps{
                checkout scm
            }
          }


          stage('Build Docker Image'){
            steps{
                sh "docker build -t jeffthorne/books:latest ."
                //sh "sleep 4"
                //sh "python3 /home/jeff/update_sha.py ${WORKSPACE}/jeffsbooks-deployment.yaml"
            }
        }


                stage('Ghost Image Assurance Scan'){
                   steps{
                        script{
                            sh "ghost image --rego-file ${WORKSPACE}/ghost.rego --format template --template \"@/home/jeff/experian.tpl\" -o /home/jeff/lw_data/lace.html jeffthorne/books:latest"

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
                            reportName: 'GhostScannerReport'
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
                        sh "kubectl  --kubeconfig=/home/jeff/config.yaml delete -f  jeffsbooks-deployment.yaml -n jeffsbooks"
                        sh "kubectl  --kubeconfig=/home/jeff/config.yaml apply -f jeffsbooks-deployment.yaml -n jeffsbooks"

                     }
                }
    }

}