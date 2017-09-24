data "null_data_source" "outputs" {
  inputs {
    prometheus_stats_dashboard = "${grafana_dashboard.prometheus_stats.slug}"
    container_stats_dashboard = "${grafana_dashboard.container_stats.slug}"
    server_stats_dashboard = "${grafana_dashboard.server_stats.slug}"
    monitor_stats_dashboard = "${grafana_dashboard.monitor_stats.slug}"
  }
}

output "grafana_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs
    )}"
}