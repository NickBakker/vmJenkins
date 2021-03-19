pipeline {
    agent any


    stages {
        
        stage('Example') {
            steps { 
                echo 'Hello World'
            }
        }
        
        stage ('Checkout Git') {
            steps {
 	            checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/SonnyBurnett/helloworld.git']]]) 
	        }
        }
        
        stage('Build') {
            steps {
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }

            post {
                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.
                success {
                    archiveArtifacts 'target/*.war'
                }
            }
        }
    }
}

