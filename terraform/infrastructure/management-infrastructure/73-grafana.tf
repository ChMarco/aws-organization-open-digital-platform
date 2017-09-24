resource "null_resource" "grafana_test" {
  provisioner "local-exec" {
    command = "until $(curl --output /dev/null --silent --head --fail http://${lookup(module.monitoring.monitoring_outputs, "monitoring_grafana_elb_dns_name")}:3000/); do printf '.' sleep 5; done"
  }
}

provider "grafana" {
  url = "http://${lookup(module.monitoring.monitoring_outputs, "monitoring_grafana_elb_dns_name")}:3000"
  auth = "admin:changeme"
}

resource "grafana_data_source" "prometheus" {
  name = "Prometheus"
  type = "prometheus"
  url = "http://${lookup(module.monitoring.monitoring_outputs, "monitoring_internal_elb_dns_name")}:9090/"
  basic_auth_enabled = true
  basic_auth_username = "admin"
  basic_auth_password = "changeme"
}

resource "grafana_dashboard" "prometheus_stats" {
  config_json = "${file("${path.module}/files/grafana/dashboards/Dashboard_Prometheus_Stats.json")}"
}

resource "grafana_dashboard" "container_stats" {
  config_json = "${file("${path.module}/files/grafana/dashboards/Dashboard_Container_Stats.json")}"
}

resource "grafana_dashboard" "server_stats" {
  config_json = "${file("${path.module}/files/grafana/dashboards/Dashboard_Server_Stats.json")}"
}

resource "grafana_dashboard" "monitor_stats" {
  config_json = "${file("${path.module}/files/grafana/dashboards/Dashboard_Monitor_Server_Stats.json")}"
}