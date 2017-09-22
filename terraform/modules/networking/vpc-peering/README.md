# VPC Peering AWS Module

Module for creating Peering Connections between Virtual Private Clouds (VPCs) on AWS.

#####Folder Structure:
```
-── vpc-peering                         # top level dir
    ├── README.md                       # description of how to use the terraform script
    ├── LICENCE                         # module licence details
    ├── 00-init.tf                      # module initialisation - terraform
    └── 10-inputs-required.tf           # module required inputs
    └── 10-inputs-defaults.tf           # module default inputs
    └── 10-interpolated-defaults.tf     # module defaults interpolated from other inputs and data sources
    └── 20-vpc-peering.tf               # core scripts for the module
    └── 99-outputs.tf                   # the output for the module
```

#####Required Inputs:
```
mgmt_vpc_id
mgmt_vpc_cidr
mgmt_vpc_shortname

vpc_id
vpc_cidr
vpc_shortname
public_route_tables
private_route_tables
dmz_route_tables

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
networks = "DMZ,Private,Public"
```

#####Outputs
```
vpc_peering_id
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
