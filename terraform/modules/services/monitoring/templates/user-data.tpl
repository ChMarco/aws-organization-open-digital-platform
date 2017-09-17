#!/bin/bash

prometheus="/mnt/efs/prometheus.yml"
alertmanager="/mnt/efs/alertmanager.yml"

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
  - "targets.rules"
  - "hosts.rules"
  - "containers.rules"

# A scrape configuration containing exactly one endpoint to scrape.
scrape_configs:

  - job_name: 'prometheus'
    ec2_sd_configs:
      - region: eu-west-1
        port: 9090
    relabel_configs:
      - source_labels: [__meta_ec2_tag_Created_By]
        regex: Terraform
        action: keep

  - job_name: 'nodeexporter'
    ec2_sd_configs:
      - region: eu-west-1
        port: 9100
    relabel_configs:
      - source_labels: [__meta_ec2_tag_Created_By]
        regex: Terraform
        action: keep

  - job_name: 'cadvisor'
    ec2_sd_configs:
      - region: us-east-1
        port: 9010
    relabel_configs:
      - source_labels: [__meta_ec2_tag_Created_By]
        regex: Terraform
        action: keep
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


service docker restart
start ecs