#!/bin/bash

block="/etc/nginx/nginx.conf"
consul_registrator="/mnt/efs/consul/consul-registrator/bin/start.sh"

EC2_INSTANCE_IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

echo ECS_CLUSTER='${ecs_cluster_name}' > /etc/ecs/ecs.config

yum-config-manager --enable epel
yum update -y
yum -y install nfs-utils
yum -y install aws-cli

mkdir -p /etc/nginx

tee $block > /dev/null <<EOF
events {
    worker_connections 1024;
}
http {
    server {
        location / {
            proxy_pass http://${jenkins_elb_dns_name};

            proxy_read_timeout 90;
            proxy_redirect default;
            proxy_set_header Host \$host:\$server_port;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Real-IP \$remote_addr;
        }
    }
}
EOF

mkdir -p /mnt/efs
mkdir -p /mnt/efs /mnt/efs/consul/consul-registrator/bin
mkdir -p /mnt/efs/jenkins

aws_az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
aws_region=${aws_region}
echo $${aws_az}.${efs_id}.efs.$${aws_region}.amazonaws.com:/    /mnt/efs   nfs4    defaults >> /etc/fstab
mount -a
chmod -R 777 /mnt/efs

usermod -a -G docker ec2-user

#
# Generate consul-registrator startup file
#

tee $consul_registrator > /dev/null <<EOF
#!/bin/sh
exec /bin/registrator -ip $${EC2_INSTANCE_IP_ADDRESS} -retry-attempts -1 consul://$${EC2_INSTANCE_IP_ADDRESS}:8500
EOF

chmod a+x $consul_registrator

sudo chown 1000 /mnt/efs/jenkins

mkdir -p /mnt/efs/jenkins/workspace/SeedJob
mkdir -p /mnt/efs/jenkins/init.groovy.d

aws s3 cp s3://${account_id}-infrastructure-terraform/terraform-scripts/jenkins/config/ /mnt/efs/jenkins/ --recursive
aws s3 cp s3://${account_id}-infrastructure-terraform/terraform-scripts/jenkins/ /mnt/efs/jenkins/workspace/SeedJob --recursive
aws s3 cp s3://${account_id}-infrastructure-terraform/terraform-scripts/jenkins/seed-job.groovy /mnt/efs/jenkins/init.groovy.d
aws s3 cp s3://${account_id}-infrastructure-terraform/terraform-scripts/jenkins/secure.groovy /mnt/efs/jenkins/init.groovy.d

service docker restart
start ecs
