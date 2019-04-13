## 设置项目基本信息

```bash
# 项目名称
$ export PROJECT_NAME="dummy"
# 项目根目录
$ export JENKINS_HOME=/jenkins_home
$ sudo mkdir -p $JENKINS_HOME/{workspace,builds,jobs}
$ sudo chown -R 1000 $JENKINS_HOME
$ sudo chmod -R a+rwx $JENKINS_HOME
```

## 准备构建

```bash
$ git clone https://github.com/CarsonFjz/ci-jenkins-with-docker.git
$ mv ci-jenkins-with-docker $PROJECT_NAME
$ cd $PROJECT_NAME
```

## 构建容器

```bash
$ docker-compose up --build --detach
```

## 完成构建

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

- 测试 docker:

```bash
$ docker exec -ti "${PROJECT_NAME}_jenkins" bash

# This command should display all docker containers
$ docker ps -a
```

## jenkins生成的ssh密钥

```bash
$ docker exec -ti -u root "${PROJECT_NAME}_jenkins" bash
$ cat /root/.ssh/*
$ exit
```

## 日志查看

```bash
$ docker logs -f `docker ps -aqf "name=${PROJECT_NAME}_jenkins"`
```

# 卸载

```bash
$ docker stop "${PROJECT_NAME}_jenkins"
$ docker rm "${PROJECT_NAME}_jenkins"
$ docker rmi "${PROJECT_NAME}_jenkins"
$ docker volume rm "${PROJECT_NAME}_jenkins_workspace"
$ docker network rm "${PROJECT_NAME}_jenkins_network"
$ sudo rm -rf $JENKINS_HOME
```
