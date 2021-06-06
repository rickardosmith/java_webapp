def getGitRevisionTag(){
    def tag = sh script: 'git rev-parse HEAD', returnStdout:true
    return tag
}

pipeline {
    agent { label 'linux' }

    options {
        ansiColor('xterm')
    }

    environment {
        Git_Revision_Tag = getGitRevisionTag()
    }

    stages {
        stage('SonarCube Analysis') {
            agent {
                docker {
                    image 'maven:3.8.1-jdk-8'
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                script {
                    withSonarQubeEnv('SonarMaven') {
                        sh 'mvn clean sonar:sonar'
                    }

                    timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
                        def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                    sh 'mvn clean install'
                }
            }
        }
        stage('Build and Launch Tomcat App') {
            steps {
                script {
                    sh """
                        cp -r ../${env.JOB_NAME}@2/target .
                        docker build . -t javawebapp
                        docker run -d -p 80:8080 --name test javawebapp
                    """
                }
            }
        }
        stage('OWASP ZAP Analysis') {
            steps {
                script {
                    sh 'docker run -t owasp/zap2docker-stable zap-baseline.py -t http://localhost || true'
                }
            }
        }
        stage('Terraform') {
            steps {
                script {
                    sh 'echo Coming soon...'
                }
            }
        }
        stage('Ansible') {
            steps {
                script {
                    sh 'echo Coming soon...'
                }
            }
        }
        stage('Build and Deploy') {
            steps {
                script {
                    sh "cp -r ../${env.JOB_NAME}@2/target ."
                    withCredentials([string(credentialsId: 'dockerHubToken', variable: 'TOKEN')]) {
                        sh """
                            docker login -u wizkiddja -p ${TOKEN}
                            docker build . -t wizkiddja/demosite:${Git_Revision_Tag}
                        """
                    }
                }
            }
        }
    }
}