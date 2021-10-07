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
                //sh "docker build -t 192.168.1.41:5000/jeffsbooks:latest ."
                sh "docker build -t 192.168.1.41:5000/books:latest ."
                //sh "sleep 4"
                //sh "python3 /home/jeff/update_sha.py ${WORKSPACE}/jeffsbooks-deployment.yaml"
            }
        }


                stage('Lacework Image Assurance Scan'){
                   steps{
                        script{
                            sh "ghost image --rego-file ${WORKSPACE}/ghost.rego --format template --template \"@${WORKSPACE}/lace.tpl\" -o /home/jeff/lw_data/lace.html --tags \"jenkins-build-${BUILD_NUMBER}\" --webhook http://192.168.1.196:9001/api/webhook 192.168.1.41:5000/jeffsbooks:latest"

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
                            //sh "docker push 192.168.1.41:5000/jeffsbooks:latest"
                            sh "docker push 192.168.1.41:5000/books:latest"
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