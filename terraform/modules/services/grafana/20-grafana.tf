/*
 * Module: Grafana
 *
 * Components:
 *   - grafana_data_source
 *   - grafana_dashboard
 */

provider "grafana" {
  url = "http://${var.grafana_public_endpoint}:3000"
  auth = "${var.grafana_username}:${var.grafana_password}"
}

resource "grafana_data_source" "prometheus" {
  name = "Prometheus"
  type = "Prometheus"
  url = "http://${var.grafana_internal_endpoint}:9090"
  basic_auth_enabled = false
}

resource "grafana_dashboard" "prometheus_stats" {
  config_json = "${file("${path.module}/files/dashboards/Dashboard_Prometheus_Stats.json")}"
}

resource "grafana_dashboard" "container_stats" {
  config_json = "${file("${path.module}/files/dashboards/Dashboard_Container_Stats.json")}"
}

resource "grafana_dashboard" "server_stats" {
  config_json = "${file("${path.module}/files/dashboards/Dashboard_Server_Stats.json")}"
}

resource "grafana_dashboard" "monitor_stats" {
  config_json = "${file("${path.module}/files/dashboards/Dashboard_Monitor_Server_Stats.json")}"
}