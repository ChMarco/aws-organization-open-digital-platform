#!/bin/bash

block="/etc/nginx/nginx.conf"

EC2_INSTANCE_IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

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
            proxy_set_header Host \$host:\$server_port;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Real-IP \$remote_addr;
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

usermod -a -G docker ec2-user

mkdir -p /opt/consul-registrator/bin

cat << EOF > /opt/consul-registrator/bin/start.sh
#!/bin/sh
exec /bin/registrator -ip $${EC2_INSTANCE_IP_ADDRESS} -retry-attempts -1 consul://$${EC2_INSTANCE_IP_ADDRESS}:8500
EOF

chmod a+x /opt/consul-registrator/bin/start.sh

service docker restart
start ecs
