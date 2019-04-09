FROM jenkins/jenkins:lts

ARG docker_compose_version=1.23.1

ENV DOCKER_COMPOSE_VERSION ${docker_compose_version}

USER root

    # Install dependencies
RUN apt-get update && apt-get -y install \
                apt-transport-https \
                ca-certificates \
                bash \
                curl \
                gnupg2 \
                gawk \
                nano \
                netcat \
                build-essential \
                libssl-dev \
                software-properties-common && \
        # generate jenkins specific ssh key
        mkdir /root/.ssh && \
                cd /root/.ssh && \
                ssh-keygen -t rsa -N "" -f id_rsa && \
                cd - && \

        # install docker
        apt-get -y install \
                docker-ce && \
        # install docker-compose
        curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
                && chmod +x /usr/local/bin/docker-compose && \
        # give jenkins docker rights
        usermod -aG docker jenkins && \
        # grant correct permissions to npm -g
        chown -R jenkins /usr/lib

WORKDIR /root

USER jenkins

ENV PATH="${GOROOT}/bin:${GOPATH}/bin:${PATH}"

WORKDIR ${JENKINS_HOME}
