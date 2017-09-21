#!/bin/bash

consul_acl="/mnt/efs/consul/config/acls.json"

echo ECS_CLUSTER='${ecs_cluster_name}' > /etc/ecs/ecs.config

yum-config-manager --enable epel
yum update -y
yum -y install nfs-utils

mkdir -p /mnt/efs /mnt/efs/consul /mnt/efs/consul/config /mnt/efs/consul/data

rm -rf /mnt/efs/consul/data/serf

aws_az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
aws_region=${aws_region}
echo $${aws_az}.${efs_id}.efs.$${aws_region}.amazonaws.com:/    /mnt/efs   nfs4    defaults >> /etc/fstab
mount -a
chmod -R 777 /mnt/efs

tee $consul_acl > /dev/null <<EOF
{
  "acl_datacenter": "${consul_dc}",
  "acl_master_token": "${consul_acl_master_token_uuid}",
  "acl_default_policy": "allow",
  "acl_down_policy": "deny"
}
EOF

service docker restart
start ecs