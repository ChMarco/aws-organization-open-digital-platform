#!/bin/bash

prometheus="/mnt/efs/prometheus.yml"
alertmanager="/mnt/efs/alertmanager.yml"

EC2_INSTANCE_IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

echo ECS_CLUSTER='${ecs_cluster_name}' > /etc/ecs/ecs.config

yum-config-manager --enable epel
yum update -y
yum -y install nfs-utils

mkdir -p /mnt/efs
mkdir -p /var/opt/prometheus

aws_az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
aws_region=${aws_region}
echo $${aws_az}.${efs_id}.efs.$${aws_region}.amazonaws.com:/    /mnt/efs   nfs4    defaults >> /etc/fstab
mount -a
chmod -R 777 /mnt/efs

tee $prometheus > /dev/null <<EOF
---
global:
  scrape_interval:     15s
  scrape_timeout:      10s
  evaluation_interval: 15s

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
      monitor: 'docker-host-alpha'

# Load and evaluate rules in this file every 'evaluation_interval' seconds.
rule_files:
  - "*.rules"

# A scrape configuration containing exactly one endpoint to scrape.
scrape_configs:

  - job_name: 'nodeexporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']

  - job_name: 'cadvisor'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:8080']

  - job_name: 'prometheus'
    scrape_interval: 10s
    static_configs:
      - targets: ['${monitoring_elb_dns_name}:9090']

  - job_name: 'instance-nodeexporter'
    ec2_sd_configs:
      - region: eu-west-1
        port: 9100
    relabel_configs:
      - source_labels: [__meta_ec2_tag_Monitoring]
        regex: On
        action: keep
      - source_labels: [__meta_ec2_tag_Name]
        target_label: instance
      - source_labels: [__meta_ec2_tag_Environment]
        target_label: env
      - source_labels: [__meta_ec2_tag_Service]
        target_label: service_type

  - job_name: 'instance-cadvisor'
    ec2_sd_configs:
      - region: eu-west-1
        port: 9191
    relabel_configs:
      - source_labels: [__meta_ec2_tag_Monitoring]
        regex: On
        action: keep
      - source_labels: [__meta_ec2_tag_Name]
        target_label: instance
      - source_labels: [__meta_ec2_tag_Environment]
        target_label: env
      - source_labels: [__meta_ec2_tag_Service]
        target_label: service_type
EOF

tee $alertmanager > /dev/null <<EOF
global:
  slack_api_url: 'https://hooks.slack.com/services/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'

route:
  group_wait: 30s
  group_by: [alertname, __meta_ec2_tag_Environment, __meta_ec2_tag_Service]
  group_interval: 5m
  repeat_interval: 24h
  receiver: 'slack-notifications'

  routes:
    - receiver: slack-notifications

receivers:
- name: 'slack-notifications'
  slack_configs:
  - channel: '{{ alert_slack_channel }}'
    text: 'Instances: {{ range .Alerts }}{{ .Labels.instance }} {{ end }}'
    send_resolved: true
EOF

usermod -a -G docker ec2-user

mkdir -p /opt/consul-registrator/bin

cat << EOF > /opt/consul-registrator/bin/start.sh
#!/bin/sh
exec /bin/registrator -ip $${EC2_INSTANCE_IP_ADDRESS} -retry-attempts -1 consul://$${EC2_INSTANCE_IP_ADDRESS}:8500
EOF

chmod a+x /opt/consul-registrator/bin/start.sh

service docker restart
start ecs