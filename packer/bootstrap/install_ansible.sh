#!/bin/bash

if [ -f /etc/centos-release ];then
  # centos-6
  # sudo rpm -iUvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

  # centos-7
  sudo yum install -y epel-release
  sudo yum clean all
  sudo yum install -y ansible python-pip
  sudo pip install --upgrade pip
  sudo pip install six
  sudo pip install docker-py
fi

if [ -f /etc/lsb-release ];then
  sudo apt-get update -y
  sudo apt-get install -y ansible
fi

