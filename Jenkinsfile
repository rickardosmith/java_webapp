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
                    withSonarQubeEnv('javaWebApp') {
                        sh 'mvn clean sonar:sonar'
                    }

                    timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
                        def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                    sh "mvn clean install"
                }
            }
        }
        stage('OWASP ZAP Analysis') {
            steps {
                script {
                    sh 'echo Coming soon...'
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
                    withCredentials([string(credentialsId: 'dockerHubToken', variable: 'TOKEN')]) {
                        sh """
                            docker login -u wizkiddja -p ${TOKEN}
                            docker build . -t wizkiddja\\demosite:${Git_Revision_Tag}
                        """
                    }
                }
            }
        }
    }
}