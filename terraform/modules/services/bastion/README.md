# Bastion AWS Module

This module deploys a Bastion host in a VPC.

This module depends on the VPC module and requires that a VPC has been created already.

#####Folder Structure:
```
-── bastion                             # top level dir
    ├── README.md                       # description of how to use the terraform script
    ├── LICENCE                         # module licence details
    ├── /templates                      # templates folder eg user data etc
    │   └── bastion-cloud-config.yml    # cloud-config init script to bootstrap the host
    ├── 00-init.tf                      # module initialisation - terraform
    └── 10-inputs-required.tf           # module required inputs
    └── 10-inputs-defaults.tf           # module default inputs
    └── 10-interpolated-defaults.tf     # module defaults interpolated from other inputs and data sources
    └── 20-bastion.tf                   # core scripts for the module
    └── 30-debug-outputs.tf             # outputs of inputs provided to the module
    └── 99-outputs.tf                   # the output for the module
```

#####Required Inputs:
```
aws_region

vpc_id
vpc_shortname

bastion_public_key
bastion_subnets
bastion_ssh_whitelist

provisioner_username
provisioner_ssh_public_key

monitoring_security_group

deploy_environment

tag_resource_name
tag_project_name
tag_environment
tag_cost_center
tag_app_operations_owner
tag_system_owner
tag_budget_owner
```

#####Default Inputs:
```
enable_debug = "true"

lc_associate_public_ip_address = "false"
lc_ami_id = ""
lc_instance_type = "t2.micro"
lc_iam_instance_profile = ""
lc_ebs_optimized = "false"
lc_root_block_device" = "gp2:16:true"

asg_min_size = "1"
asg_max_size = "1"
asg_desired_capacity = "1"
asg_health_check_type = "EC2"
asg_force_delete = "true"
asg_termination_policies = "OldestInstance"
asg_health_check_grace_period = "180"

bastion_ami" {
    type = "map"
    description = "Amazon Linux AMI VPC NAT x86_64 HVM GP2"
    default = {
        "eu-west-1" = "ami-6975eb1e"
        "us-east-1" = "ami-303b1458"
        "ap-southeast-2" = "ami-43ee9e79"
    }
}

tag_monitoring= "On"
```

#####Outputs
```
bastion_outputs = {
  bastion_autoscaling_group_arn
  bastion_autoscaling_group_id
  bastion_eip_id
  bastion_eip_public_ip
  bastion_iam_instance_profile_arn
  bastion_iam_instance_profile_id
  bastion_iam_instance_profile_name
  bastion_iam_policy_arn
  bastion_iam_policy_id
  bastion_iam_policy_name
  bastion_key_pair_name
  bastion_launch_configuration_id
  bastion_launch_configuration_name
  bastion_role_arn
  bastion_security_group_id
}
```

## What's a Module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such 
as a database or server cluster. Each Module is created using [Terraform](https://www.terraform.io/), and
includes automated tests, examples, and documentation. It is maintained both by the open source community and 
companies that provide commercial support. 

Instead of figuring out the details of how to run a piece of infrastructure from scratch, you can reuse 
existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, 
you can leverage the work of the Module community to pick up infrastructure improvements through
a version number bump.

## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release, 
along with the changelog, in the [Releases Page](../../releases). 

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a 
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR, 
MINOR, and PATCH versions on each release to indicate any incompatibilities. 

## License

This code is released under the Apache 2.0 License. Please see [LICENSE](https://github.com/hashicorp/terraform-aws-consul/tree/master/LICENSE) and [NOTICE](https://github.com/hashicorp/terraform-aws-consul/tree/master/NOTICE) for more 
details.
