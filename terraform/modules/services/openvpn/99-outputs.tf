data "null_data_source" "outputs" {
  inputs {
    openvpn_key_pair_name = "${aws_key_pair.openvpn_key_pair.key_name}"
    openvpn_security_group_id = "${aws_security_group.openvpn_security_group.id}"
    openvpn_role_arn = "${aws_iam_role.openvpn_role.arn}"
    openvpn_iam_instance_profile_id = "${aws_iam_instance_profile.openvpn_instance_profile.id}"
    openvpn_iam_instance_profile_arn = "${aws_iam_instance_profile.openvpn_instance_profile.arn}"
    openvpn_iam_instance_profile_name = "${aws_iam_instance_profile.openvpn_instance_profile.name}"
    openvpn_iam_policy_id = "${aws_iam_policy.openvpn_iam_policy.id}"
    openvpn_iam_policy_arn = "${aws_iam_policy.openvpn_iam_policy.arn}"
    openvpn_iam_policy_name = "${aws_iam_policy.openvpn_iam_policy.name}"
    openvpn_elb_dns_name = "${aws_elb.openvpn_elb.dns_name}"
  }
}

output "openvpn_outputs" {
  value = "${merge(
        data.null_data_source.outputs.inputs
    )}"
}