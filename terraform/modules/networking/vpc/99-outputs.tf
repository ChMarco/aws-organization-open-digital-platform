output "vpc_outputs" {
  value = "${merge(
        data.null_data_source.vpc_outputs.inputs,
        data.null_data_source.connectivity_outputs.inputs,
        data.null_data_source.endpoints_outputs.inputs
    )}"
}
