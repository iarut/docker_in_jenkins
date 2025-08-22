#FROM jenkins/jenkins:lts-jdk17
#
#USER root
#
## Установка Docker CLI
#RUN apt-get update && \
#    apt-get install -y \
#        apt-transport-https \
#        ca-certificates \
#        curl \
#        gnupg2 \
#        lsb-release && \
#    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg && \
#    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
#        > /etc/apt/sources.list.d/docker.list && \
#    apt-get update && \
#    apt-get install -y docker-ce-cli && \
#    usermod -aG docker jenkins && \
#    rm -rf /var/lib/apt/lists/*
#
## Установка Maven
#RUN apt-get update && \
#    apt-get install -y maven && \
#    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
#    rm -rf /var/lib/apt/lists/*
#
#ENV PATH="/usr/share/maven/bin:${PATH}"
## Установка плагинов Jenkins
#COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
#RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
#
## Переключаемся на пользователя Jenkins
#USER jenkins

# https://github.com/jenkinsci/docker/blob/master/README.md
FROM jenkins/jenkins:lts
MAINTAINER blankhang@gmil.com

USER root

# install docker cli
RUN apt-get -y update; apt-get install -y sudo; apt-get install -y git wget
RUN echo "Jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN wget http://get.docker.com/builds/Linux/x86_64/docker-latest.tgz
RUN tar -xvzf docker-latest.tgz
RUN mv docker/* /usr/bin/

# update system and install chinese language support and maven nodejs
RUN apt-get update && apt-get install -y locales locales-all maven nodejs \
    && sed -i '/^#.* zh_CN.UTF-8 /s/^#//' /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/* \

## Setting Default Chinese Language and UTC+8 timezone
##ENV LANG C.UTF-8
#ENV LANG zh_CN.UTF-8
#ENV LANGUAGE zh_CN.UTF-8
#ENV LC_ALL zh_CN.UTF-8
#ENV TZ Asia/Shanghai

USER Jenkins