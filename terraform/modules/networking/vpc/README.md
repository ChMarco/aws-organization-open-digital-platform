# VPC AWS Module

Module for creating best-practices Virtual Private Clouds (VPCs) on AWS.

#####Folder Structure:
```
-── vpc                                 # top level dir
    ├── README.md                       # description of how to use the terraform script
    ├── LICENCE                         # module licence details
    ├── 00-init.tf                      # module initialisation - terraform
    └── 10-inputs-required.tf           # module required inputs
    └── 10-inputs-defaults.tf           # module default inputs
    └── 10-interpolated-defaults.tf     # module defaults interpolated from other inputs and data sources
    └── 20-vpc.tf                       # core scripts for the module
    └── 30-debug-outputs.tf             # outputs of inputs provided to the module
    └── 40-vpc-outputs.tf               # outputs of vpc resources
    └── 50-connectivity-outputs.tf      # outputs of connectivity resources
    └── 60-endpoint-outputs.tf          # outputs of endpoint resources
    └── 99-outputs.tf                   # the output for the module
```

#####Required Inputs:
```
aws_region

vpc_description
vpc_shortname
vpc_cidr_block

dmz_subnet_cidr_blocks
public_subnet_cidr_blocks
private_subnet_cidr_blocks

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
enable_dns_support= "true"
enable_dns_hostnames = "true"
```

#####Outputs
```
vpc_outputs = {
  dmz_rt_id
  dmz_subnet_ids
  dmz_subnet_rta_ids
  dynamodb_vpc_endpoint_id
  igw_id
  natgw_allocation_ids
  natgw_eip_ids
  natgw_eip_public_ips
  natgw_ids
  natgw_private_ips
  natgw_public_ips
  natgw_subnet_ids
  private_rt_id
  private_subnet_ids
  private_subnet_rta_ids
  public_rt_id
  public_subnet_ids
  public_subnet_rta_ids
  s3_vpc_endpoint_id
  vgw_id
  vpc_cidr_block
  vpc_discovery_security_group
  vpc_id
  vpc_monitoring_security_group
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
