## Setup your host

```bash
# setup your project name
$ export PROJECT_NAME="dummy"
# setup the desired path to jenkins_home
$ export JENKINS_HOME=/path/to/desired/jenkins_home
$ sudo mkdir -p $JENKINS_HOME/{workspace,builds,jobs}
$ sudo chown -R 1000 $JENKINS_HOME
$ sudo chmod -R a+rwx $JENKINS_HOME
```

## Setup your project

```bash
$ git clone https://github.com/CarsonFjz/ci-jenkins-with-docker.git
$ mv ci-jenkins-with-docker $PROJECT_NAME
$ cd $PROJECT_NAME
```

## Run the container

```bash
$ docker-compose up --build --detach
```

## Complete the installation

- Connect to the running container as root:

```bash
$ docker exec -ti -u root "${PROJECT_NAME}_jenkins" bash
```

- 这里这么做是因为docker容器启动后才会有docker.sock产生,不能提前给它授权,所以要事后给他权限

```bash
# change ownership of docker socket to jenkins user
$ chown jenkins /var/run/docker.sock

# exit
$ exit
```

- Test docker:

```bash
$ docker exec -ti "${PROJECT_NAME}_jenkins" bash

# This command should display all docker containers
$ docker ps -a
```

## Retrieve your ssh keys generated for your jenkins

```bash
$ docker exec -ti -u root "${PROJECT_NAME}_jenkins" bash
$ cat /root/.ssh/*
$ exit
```

## Logs

```bash
$ docker logs -f `docker ps -aqf "name=${PROJECT_NAME}_jenkins"`
```

# Uninstall

```bash
$ docker stop "${PROJECT_NAME}_jenkins"
$ docker rm "${PROJECT_NAME}_jenkins"
$ docker rmi "${PROJECT_NAME}_jenkins"
$ docker volume rm "${PROJECT_NAME}_jenkins_workspace"
$ docker network rm "${PROJECT_NAME}_jenkins_network"
$ sudo rm -rf $JENKINS_HOME
```
