data "null_data_source" "vpc_defaults" {
    inputs = {
        name_prefix = "${format("%s",
            var.vpc_shortname
        )}"
    }
}
