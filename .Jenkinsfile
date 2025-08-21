pipeline {
//     agent {
//         docker {
//             image 'maven:3.8.8-openjdk-17'
//         }
//     }
    agent any
        environment {
            // Пусть Docker использует сокет хоста
            DOCKER_HOST = "unix:///var/run/docker.sock"
        }
    stages {

        stage('Version') {
            steps {
                sh 'mvn --version'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean install'
                stash includes: 'target/*.jar', name: 'builtJar'
            }
        }
       stage('Build Docker Image') {
           agent any
           steps {
               unstash 'builtJar'
               script {
                   // Find the JAR file
                   def files = findFiles(glob: 'target/*.jar')
                   if (!files || files.length == 0) {
                       error("No JAR files found to process")
                   }
                   def jarFile = files[0].name
                   echo "Found JAR file: ${jarFile}"

                   // Write Dockerfile
                   writeFile file: 'Dockerfile', text: """
       FROM openjdk:17-jdk-slim
       COPY target/${jarFile} app.jar
       ENTRYPOINT ["java", "-jar", "app.jar"]
       """

                   // Build Docker image using named arguments
                   sh "docker build -t my-app:${env.BUILD_ID} -f Dockerfile ."
               }
           }
       }
    }
}
post {
        success {
            steps {
                echo 'Build completed successfully!'
            }
        }
        failure {
            steps {
                echo 'Build failed!'
            }
        }
    }