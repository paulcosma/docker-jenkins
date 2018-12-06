# docker-jenkins

## Change Docker ID
### Get GID of Docker Host:
```sh
getent group docker | awk -F: '{printf "Group %s with GID=%d\n", $1, $3}'
```

### Find user with id 999:
```sh
getent passwd 999 | cut -d: -f1
```
If another user is using id 999, change it. (e.g. change to 1005)

### Change Docker id to 999 (id 1000 is used by jenkins):
```sh
usermod -u 999 docker
groupmod -g 999 docker
```

### Verify changes:
```sh
id docker
getent group docker | awk -F: '{printf "Group %s with GID=%d\n", $1, $3}'
```

## Create image:
```sh
docker image build -f jenkins.Dockerfile --build-arg DOCKER_GID=999 -t paulcosma/jenkins-docker .
```
## Run container:
Replace DOCKER_GID with docker group GID from Docker host
```sh
docker run -dit --restart always --name jenkins-docker -p 8080:8080 -p 49187:49187 --env JENKINS_SLAVE_AGENT_PORT=49187 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker -v /tmp:/tmp --env JAVA_OPTS=-Dhudson.model.DirectoryBrowserSupport.CSP="" paulcosma/jenkins-docker
```


