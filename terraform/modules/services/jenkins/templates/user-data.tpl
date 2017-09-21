#!/bin/bash

block="/etc/nginx/nginx.conf"
consul_registrator="/mnt/efs/consul/consul-registrator/bin/start.sh"

EC2_INSTANCE_IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

echo ECS_CLUSTER='${ecs_cluster_name}' > /etc/ecs/ecs.config

yum-config-manager --enable epel
yum update -y
yum -y install nfs-utils

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

#
# Generate linkerd config file
#

# The linkerd ECS task definition is configured to mount this config file into
# its own Docker environment.

mkdir -p /etc/linkerd

cat << EOF > /etc/linkerd/linkerd.yaml
admin:
  ip: 0.0.0.0
  port: 9990

namers:
- kind: io.l5d.consul
  host: $${EC2_INSTANCE_IP_ADDRESS}
  port: 8500

telemetry:
- kind: io.l5d.prometheus
- kind: io.l5d.recentRequests
  sampleRate: 0.25

usage:
  orgId:

routers:
- protocol: http
  label: outgoing
  servers:
  - ip: 0.0.0.0
    port: 4140
  interpreter:
    kind: default
    transformers:
    # tranform all outgoing requests to deliver to incoming linkerd port 4141
    - kind: io.l5d.port
      port: 4141
  dtab: |
    /svc => /#/io.l5d.consul/${consul_dc};
- protocol: http
  label: incoming
  servers:
  - ip: 0.0.0.0
    port: 4141
  interpreter:
    kind: default
    transformers:
    # filter instances to only include those on this host
    - kind: io.l5d.specificHost
      host: $${EC2_INSTANCE_IP_ADDRESS}
  dtab: |
    /svc => /#/io.l5d.consul/${consul_dc};
EOF

service docker restart
start ecs
