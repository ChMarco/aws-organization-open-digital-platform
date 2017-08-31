#!/bin/bash

block="/etc/nginx/nginx.conf"

echo ECS_CLUSTER='${ecs_cluster_name}' > /etc/ecs/ecs.config

yum-config-manager --enable epel
yum update -y
yum -y install nfs-utils

mkdir -p /etc/nginx
touch /etc/nginx/nginx.conf
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
            proxy_set_header Host ${host}:${server_port};
            proxy_set_header X-Forwarded-For ${proxy_add_x_forwarded_for};
            proxy_set_header X-Real-IP ${remote_addr};
        }
    }
}
EOF

mkdir -p /mnt/efs
aws_az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
aws_region=${aws_region}
echo $${aws_az}.${efs_id}.efs.$${aws_region}.amazonaws.com:/    /mnt/efs   nfs4    defaults >> /etc/fstab
mount -a
chmod -R 777 /mnt/efs
service docker restart
start ecs
