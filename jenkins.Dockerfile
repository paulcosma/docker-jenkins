FROM jenkins/jenkins:lts

# Setting the number of executors
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

# Change JNLP Slave port
ENV JENKINS_SLAVE_AGENT_PORT 49187

# Execute docker commands on Jenkins
USER root
RUN apt-get update && apt-get install -y libltdl7 && rm -rf /var/lib/apt/lists/*
ARG DOCKER_GID=999
RUN groupadd -g ${DOCKER_GID} docker \
 && usermod -aG docker jenkins

# Drop back to the regular jenkins user
USER jenkins