pipeline {
  agent { label 'docker_root' }
  environment {
        DEPLOY_TO = 'master'
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '3'))
  }
  triggers {
    cron('@daily')
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'master',
        credentialsId: '747596f4-8a62-4f10-889a-09db1e9cc9ae',
        url: 'git@github.com:paulcosma/docker-jenkins.git'

      }
    }
    stage('Build') {
      steps {
        sh 'docker image build --no-cache -f jenkins.Dockerfile --build-arg DOCKER_GID=999 -t paulcosma/jenkins-docker .'
      }
    }
    stage('Login') {
      steps {
        sh 'docker login'
      }
    }
    stage('Publish') {
      when {
        // branch 'master'
        environment name: 'DEPLOY_TO', value: 'master'
      }
      steps {
        withDockerRegistry([ credentialsId: "e80fc77a-7fce-4fbd-98ee-c7aa4d5a6952", url: "" ]) {
          sh 'docker push paulcosma/jenkins-docker:latest'
        }
      }
    }
    stage('Start Jenkins') {
      steps {
        sh 'docker stop jenkins-docker || true && docker rm jenkins-docker || true'
        sh 'docker run -dit --restart always --name jenkins-docker -p 8080:8080 -p 49187:49187 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker -v /tmp:/tmp --env JAVA_OPTS=-Dhudson.model.DirectoryBrowserSupport.CSP="" paulcosma/jenkins-docker'
      }
    }
  }
}
