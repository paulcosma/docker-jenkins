pipeline {
  agent { label 'media' }
  environment {
        DEPLOY_TO = 'master'
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '1'))
  }
  triggers {
    cron('@weekly')
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'master',
        credentialsId: '963308e5-d6be-4086-909f-2e94ebaada7f',
        url: 'git@github.com:paulcosma/docker-jenkins.git'
        sh 'docker pull jenkins/jenkins:lts'
      }
    }
    stage('Get latest Jenkins image') {
          steps {
            sh 'docker image pull jenkins/jenkins:latest'
          }
    }
    stage('Build') {
      steps {
        sh 'docker image build -f jenkins.Dockerfile --build-arg DOCKER_GID=994 -t paulcosma/jenkins-docker:latest .'
        sh 'docker image build -f jenkins.Dockerfile --build-arg DOCKER_GID=999 -t paulcosma/jenkins-docker:999 .'
      }
    }
    stage('Publish') {
      steps {
        withDockerRegistry([ credentialsId: "052cba25-f00d-4ff2-b593-4e143b90515a", url: "" ]) {
          sh 'docker push paulcosma/jenkins-docker:latest'
          sh 'docker push paulcosma/jenkins-docker:999'
        }
      }
    }
    // stage('Start Jenkins') {
    //   steps {
    //     sh 'docker stop jenkins-docker || true && docker rm jenkins-docker || true'
    //     sh 'docker run -dit --restart always --name jenkins-docker -p 8080:8080 -p 49187:49187 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker -v /tmp:/tmp --env JAVA_OPTS=-Dhudson.model.DirectoryBrowserSupport.CSP="" paulcosma/jenkins-docker'
    //   }
    // }
  }
}