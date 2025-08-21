pipeline {
    agent any

    environment {
        APP_NAME = "my-app"
    }

    stages {
        stage('Build') {
                    steps {
                        sh 'mvn clean package'
                    }
                }

        stage('Check JAR') {
            steps {
                script {
                    // Получаем имя JAR-файла
                    def jarFiles = sh(script: "ls target/*.jar || true", returnStdout: true).trim().split("\n")
                    if (jarFiles.size() == 0 || jarFiles[0] == "") {
                        error "JAR file not found in target directory."
                    }
                    env.JAR_FILE = jarFiles[0]
                    echo "Found JAR: ${env.JAR_FILE}"
                }
            }
        }

        stage('Build Docker Image') {
            agent any
            steps {
                script {
                    // Создаем Dockerfile, если его нет
                    if (!fileExists('Dockerfile')) {
                        writeFile file: 'Dockerfile', text: """
                            FROM openjdk:17-jdk-slim
                            COPY ${env.JAR_FILE} app.jar
                            ENTRYPOINT ["java", "-jar", "app.jar"]
                        """
                    }

                    // Собираем Docker-образ
                    sh "docker build -t ${APP_NAME}:${env.BUILD_ID} ."
                }
            }
        }
    }

    post {
        success {
            echo 'Build completed successfully!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}