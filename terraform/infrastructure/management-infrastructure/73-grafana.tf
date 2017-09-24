//module "grafana" {
//  source = "../../modules/services/grafana"
//
//  grafana_public_endpoint = "${lookup(module.monitoring.monitoring_outputs, "monitoring_grafana_elb_dns_name")}"
//  grafana_internal_endpoint = "${lookup(module.monitoring.monitoring_outputs, "monitoring_internal_elb_dns_name")}"
//
//  grafana_username = "${var.grafana_username}"
//  grafana_password = "${var.grafana_password}"
//}