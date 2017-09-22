# Discovery AWS Module

This module deploys a [Consul](https://www.consul.io/) cluster on 
[AWS](https://aws.amazon.com/) using [Terraform](https://www.terraform.io/). Consul is a distributed, highly-available 
tool that you can use for service discovery and key/value storage. A Consul cluster typically includes a small number
of server nodes, which are responsible for being part of the [consensus 
quorum](https://www.consul.io/docs/internals/consensus.html), and a larger number of client nodes, which you typically 
run alongside your apps

#####Folder Structure:
```
-── discovey                                        # top level dir
    ├── README.md                                   # description of how to use the terraform script
    ├── LICENCE                                     # module licence details
    ├── /templates                                  # templates folder eg user data etc
    │   └── discovery_consul_agent.json.tpl         # 
    │   └── discovery_consul_registrator.json.tpl   # 
    │   └── discovery_consul_server.json.tpl        # 
    │   └── user-data.tpl                           # 
    ├── 00-init.tf                                  # module initialisation - terraform
    └── 10-inputs-required.tf                       # module required inputs
    └── 10-inputs-defaults.tf                       # module default inputs
    └── 10-interpolated-defaults.tf                 # module defaults interpolated from other inputs and data sources
    └── 20-discovery.tf                             # core scripts for the module
    └── 30-debug-outputs.tf                         # outputs of inputs provided to the module
    └── 99-outputs.tf                               # the output for the module
```

#####Required Inputs:
```
aws_region

vpc_id
vpc_shortname

discovery_public_key
discovery_subnets
discovery_elb_subnets
discovery_ssh_bastion_access
discovery_web_whitelist

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

service_desired_count = 3

discovery_ami" {
    type = "map"
    description = "AWS ECS optimized images"
    default = {
        "eu-west-1" = "ami-4e6ffe3d"
        "us-east-1" = "ami-8f7687e2"
        "ap-southeast-2" = "ami-697a540a"
    }
}

tag_monitoring= "On"
```

#####Outputs
```
discovery_outputs = {
  discovery_autoscaling_group_arn
  discovery_autoscaling_group_id
  discovery_consul_agent_ecs_task_definition_arn
  discovery_consul_alb_dns_name
  discovery_consul_alb_listner_arn
  discovery_consul_alb_security_group
  discovery_consul_alb_target_group_arn
  discovery_consul_ecs_service_id
  discovery_consul_ecs_task_arn
  discovery_consul_registrator_ecs_task_definition_arn
  discovery_ecs_cluster_id
  discovery_efs_id
  discovery_efs_mount_target_ids
  discovery_efs_security_group_id
  discovery_iam_instance_profile_arn
  discovery_iam_instance_profile_id
  discovery_iam_instance_profile_name
  discovery_iam_policy_arn
  discovery_iam_policy_id
  discovery_iam_policy_name
  discovery_key_pair_name
  discovery_launch_configuration_id
  discovery_launch_configuration_name
  discovery_role_arn
  discovery_security_group_id
  efs_backup_aws_cloudwatch_event_rule_arn
  efs_backup_ecs_task_definition_arn
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
