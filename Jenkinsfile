pipeline {
    agent { label 'dev' }
    environment{
        SONAR_HOME = tool "sonar"
    }
    stages {

        stage("code"){
            steps{
                git url: "https://github.com/iamamash/Node-Todo-CICD.git", branch: "master"
                echo 'Code cloned'
            }
        }
        stage("SonarQube Analysis"){
            steps{
               withSonarQubeEnv("sonar"){
                   sh "$SONAR_HOME/bin/sonar-scanner -X"
                   echo 'SonarQube analysis done'
               }
            }
        }
        stage("SonarQube Quality Gates"){
            steps{
               timeout(time: 1, unit: "MINUTES"){
                   waitForQualityGate abortPipeline: false
               }
            }
        }
        stage("OWASP"){
            steps{
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'OWASP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                echo 'OWASP analysis done'
            }
        }
        stage("build and test"){
            steps{
                sh "docker build -t node-app ."
                echo 'Docker build completed'
            }
        }
        stage("Trivy"){
            steps{
                sh "trivy image node-app"
                echo 'Image scanning completed'
            }
        }
        stage("push"){
            steps{
                withCredentials([usernamePassword(credentialsId:"dockerhub",passwordVariable:"password",usernameVariable:"user")]){
                    sh "docker login -u ${env.user} -p ${env.password}"
                    sh "docker tag node-app:latest ${env.user}/node-app:latest"
                    sh "docker push ${env.user}/node-app:latest"
                    echo 'Image pushed'
                }
            }
        }
        stage("deploy"){
            steps{
                sh "docker-compose down && docker-compose up -d"
                echo 'Deployment done!'
            }
        }
    }
}
