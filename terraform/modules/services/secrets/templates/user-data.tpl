#!/bin/bash

consul_registrator="/mnt/efs/consul/consul-registrator/bin/start.sh"

echo ECS_CLUSTER='${ecs_cluster_name}' > /etc/ecs/ecs.config

EC2_INSTANCE_IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

yum-config-manager --enable epel
yum update -y
yum -y install nfs-utils

mkdir -p /mnt/efs /mnt/efs/vault/policies
mkdir -p /mnt/efs/consul/consul-registrator/bin

aws_az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
aws_region=${aws_region}
echo $${aws_az}.${efs_id}.efs.$${aws_region}.amazonaws.com:/    /mnt/efs   nfs4    defaults >> /etc/fstab
mount -a
chmod -R 777 /mnt/efs

tee $consul_registrator > /dev/null <<EOF
#!/bin/sh
exec /bin/registrator -ip $${EC2_INSTANCE_IP_ADDRESS} -retry-attempts -1 consul://$${EC2_INSTANCE_IP_ADDRESS}:8500
EOF

chmod a+x $consul_registrator
service docker restart
start ecs