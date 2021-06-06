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
                    sh "cp -r ../${env.JOB_NAME}@2/target ."
                    sh 'docker build -t javawebapp .'
                    sh 'if [ "$(docker ps | grep test)" ]; then docker kill test; fi'
                    sh 'if [ "$(docker ps -a | grep test)" ]; then docker rm test; fi'
                    sh 'docker run -d -p 8031:8080 --name test javawebapp'
                }
            }
        }
        stage('OWASP ZAP Analysis') {
            steps {
                script {
                    sh 'if [ "$(docker ps | grep owasp-zap)" ]; then docker kill owasp-zap; fi'
                    sh 'if [ "$(docker ps -a | grep owasp-zap)" ]; then docker rm owasp-zap; fi'
                    sh 'docker run --name owasp-zap -t owasp/zap2docker-stable zap-baseline.py -t http://192.168.50.200:8031'
                }
            }
        }
        // stage('Container Clean-Up') {
        //     steps {
        //         script {
        //             // sh 'docker kill $(docker ps -q)'
        //             // sh 'docker rm $(docker ps -a -q)'
        //             // sh 'docker rmi $(docker images -q)'
        //         }
        //     }
        // }
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
        // stage('Build and Deploy') {
        //     steps {
        //         script {
        //             sh "cp -r ../${env.JOB_NAME}@2/target ."
        //             withCredentials([string(credentialsId: 'dockerHubToken', variable: 'TOKEN')]) {
        //                 sh """
        //                     docker login -u wizkiddja -p ${TOKEN}
        //                     docker build . -t wizkiddja/demosite:${Git_Revision_Tag}
        //                 """
        //             }
        //         }
        //     }
        // }
    }
}