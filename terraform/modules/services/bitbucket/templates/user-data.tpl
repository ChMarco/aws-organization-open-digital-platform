#!/bin/bash

echo ECS_CLUSTER='${ecs_cluster_name}' > /etc/ecs/ecs.config

yum-config-manager --enable epel
yum update -y
yum -y install nfs-utils

mkdir -p /var/bitbucket
aws_az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
aws_region=${aws_region}
echo $${aws_az}.${efs_id}.efs.$${aws_region}.amazonaws.com:/    /var/bitbucket   nfs4    defaults >> /etc/fstab
mount -a
chmod -R 777 /var/bitbucket
service docker restart
start ecs
