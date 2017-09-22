# Jenkins AWS Module

Module to setup a [Jenkins](https://jenkins.io/) CI server with seed jobs.

#####Folder Structure:
```
-── jenkins                                         # top level dir
    ├── README.md                                   # description of how to use the terraform script
    ├── LICENCE                                     # module licence details
    ├── /dsl                                        # templates folder eg user data etc
    │   └── /jobs                                   #
    │   └── /scripts                                #
    │   └── /views                                  #
    │   └── seed-job.groovy                         #
    │   └── basic-security.groovy                   #
    ├── /templates                                  # templates folder eg user data etc
    │   └── jenkins.json.tpl                        #
    │   └── jenkins_proxy.json.tpl                  #
    │   └── user-data.tpl                           # 
    ├── 00-init.tf                                  # module initialisation - terraform
    └── 10-inputs-required.tf                       # module required inputs
    └── 10-inputs-defaults.tf                       # module default inputs
    └── 10-interpolated-defaults.tf                 # module defaults interpolated from other inputs and data sources
    └── 20-monitoring.tf                            # core scripts for the module
    └── 30-debug-outputs.tf                         # outputs of inputs provided to the module
    └── 99-outputs.tf                               # the output for the module
```

#####Required Inputs:
```
aws_region

vpc_id
vpc_shortname

jenkins_public_key
jenkins_subnets
jenkins_elb_subnets
jenkins_ssh_bastion_access
jenkins_web_whitelist

monitoring_security_group
discovery_security_group
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
lc_instance_type = "t2.medium"
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

service_desired_count = 1

jenkins_ami" {
    type = "map"
    description = "AWS ECS optimized images"
    default = {
        "eu-west-1" = "ami-4e6ffe3d"
        "us-east-1" = "ami-8f7687e2"
        "ap-southeast-2" = "ami-697a540a"
    }
}

tag_Monitoring = "On"
```

#####Outputs
```
jenkins_outputs = {
  efs_backup_aws_cloudwatch_event_rule_arn
  efs_backup_ecs_task_definition_arn
  jenkins_autoscaling_group_arn
  jenkins_autoscaling_group_id
  jenkins_ecs_cluster_id
  jenkins_ecs_service_id
  jenkins_ecs_task_definition_arn
  jenkins_efs_id
  jenkins_efs_mount_target_ids
  jenkins_efs_security_group_id
  jenkins_elb_dns_name
  jenkins_iam_instance_profile_arn
  jenkins_iam_instance_profile_id
  jenkins_iam_instance_profile_name
  jenkins_iam_policy_arn
  jenkins_iam_policy_id
  jenkins_iam_policy_name
  jenkins_key_pair_name
  jenkins_launch_configuration_id
  jenkins_launch_configuration_name
  jenkins_proxy_ecs_service
  jenkins_proxy_ecs_task_definition_arn
  jenkins_proxy_elb_dns_name
  jenkins_proxy_elb_security_group_id
  jenkins_role_arn
  jenkins_security_group_id
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
