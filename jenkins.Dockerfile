FROM jenkins/jenkins:lts
LABEL maintainer="paulcosma@gmail.com"

# Setting the number of executors
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

# Change JNLP Slave port
ENV JENKINS_SLAVE_AGENT_PORT 49187

# Preinstalling plugins
RUN jenkins-plugin-cli \
    --plugins \
    authorize-project:latest \
    basic-branch-build-strategies:latest \
    blueocean \
    docker-plugin:latest \
    extensible-choice-parameter:latest  \
    git \
    git-parameter:latest \
    git-tag-message:latest \ 
    gitlab-plugin:latest \
    greenballs:latest \
    groovy:latest \
    jobConfigHistory:latest \
    kubernetes:latest \
    maven-plugin:latest \
    saferestart:latest \
    workflow-aggregator

# Execute docker commands on Jenkins
USER root
RUN apt-get update && apt-get install -y libltdl7 && rm -rf /var/lib/apt/lists/*
ARG DOCKER_GID=998
RUN groupadd -g ${DOCKER_GID} docker \
 && usermod -aG docker jenkins

# Drop back to the regular jenkins user
USER jenkins
