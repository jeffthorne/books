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
                sh "docker build -t us.gcr.io/test-bbfc6/jeffsbooks:latest ."
                //sh "sleep 4"
                //sh "python3 /home/jeff/update_sha.py ${WORKSPACE}/jeffsbooks-deployment.yaml"
            }
        }


                stage('Ghost Image Assurance Scan'){
                   steps{
                        script{
                            sh "ghost image --rego-file ${WORKSPACE}/ghost.rego --format template --template \"@${WORKSPACE}/lace.tpl\" -o /home/jeff/lw_data/lace.html us.gcr.io/test-bbfc6/jeffsbooks:latest"

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
                            sh "docker push us.gcr.io/test-bbfc6/jeffsbooks:latest"
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