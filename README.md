# docker-jenkins
Jenkins in docker with access to host docker.

## Change Docker ID
#### Get GID of Docker Host:
```sh
getent group docker | awk -F: '{printf "Group %s with GID=%d\n", $1, $3}'
```

#### Find user with id 998:
```sh
getent passwd 998 | cut -d: -f1
```
If any user is using id 998 change it (e.g. use 1005 instead)

#### Change Docker id and gid to 998 (id 1000 is used by jenkins):
```sh
usermod -u 998 docker
groupmod -g 998 docker
```

#### Verify new Docker id and gid:
```sh
id docker
getent group docker | awk -F: '{printf "Group %s with GID=%d\n", $1, $3}'
```

## Create image:
```sh
docker image build -f jenkins.Dockerfile --build-arg DOCKER_GID=998 -t paulcosma/jenkins-docker .
```
## Run container:
Replace DOCKER_GID with docker group GID from Docker host
```sh
docker run -dit --restart always --name jenkins-docker -p 8080:8080 -p 49187:49187 --env JENKINS_SLAVE_AGENT_PORT=49187 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker --env JAVA_OPTS=-Dhudson.model.DirectoryBrowserSupport.CSP="" paulcosma/jenkins-docker
```

### Jenkins Slaves
Install Java on VM and add it as a Jenkins slave.
```
apt update && apt install default-jre
```
