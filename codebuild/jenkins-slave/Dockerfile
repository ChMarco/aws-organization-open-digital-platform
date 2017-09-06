FROM jenkinsci/jnlp-slave

# Software version
ARG TERRAFORM_VERSION="0.10.2"
ARG PACKER_VERSION="0.11.0"
ARG ANSIBLE_VERSION="2.1.2.0"
ARG AWS_VERSION="1.10.19"
ARG DOCKER_ENGINE_VERSION=1.12.3-1.el7.centos
ARG DOCKER_COMPOSE_VERSION=1.8.1
ARG DOCKER_MACHINE_VERSION=v0.8.1
ARG PYPARSER_VERSION="2.13"
ARG AZURE_VERSION="2.0.0rc5"

# Pre-requisites
USER root

RUN apt-get update
RUN apt-get install -y git \
    wget \
    tar \
    build-essential \
    checkinstall \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    openssl \
    perl \
    python-pip \
    python-dev \
    build-essential \
    unzip
RUN cd /usr/src && \
    wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz && \
    tar xzf Python-2.7.13.tgz && \
    cd Python-2.7.13 && \
    ./configure && \
    make altinstall

RUN pip install awscli==${AWS_VERSION} ansible==${ANSIBLE_VERSION} pycparser==${PYPARSER_VERSION} azure==${AZURE_VERSION} msrestazure ansible-lint behave selenium testinfra pywinrm

RUN curl -fsSL https://get.docker.com/ | sed "s/docker-engine/docker-engine-${DOCKER_ENGINE_VERSION}/" | sh

RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    curl -L https://github.com/docker/machine/releases/download/${DOCKER_MACHINE_VERSION}/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine && \
    curl -s -o /tmp/terraform.zip -k https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip /tmp/terraform.zip -d /usr/bin && \
    chmod +x /usr/bin/terraform && \
    curl -s -o /tmp/packer.zip -k https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip /tmp/packer.zip -d /usr/bin && \
    chmod +x /usr/bin/packer
