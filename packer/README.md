packer
======

Packer is a tool to create a "golden" image, or AMI with which to spin up working servers.

Immutable Infrastructure is an architectural design approach where all configuration gets "baked into" the AMI
or gold image, rather than performed after boot by e.g. puppet/ansible/chef. Immutable Infrastructure has 
several advantages over configuration management in that

- The entire server is managed, rather than just the resources mentioned in puppet/ansible/chef
- The entire server image can be tested for validity
- Therefore it can be guaranteed to work when booted, requiring no dependencies e.g. working puppet-master, 
  working repositories for installations etc.

Guide to files
==============

ansible/ :            Configuration management for building each of the key server types 
                      within the packer process itself.

ec2.json:             A packer template for building AMI images for AWS estates
  The following environment variables need defining:
    AWS_ACCOUNT_IDS
    AMI_PRINCIPAL_REGION
    AMI_OTHER_REGIONS
    PACKER_BUILD_UID


Usage
=====

A packer wrapper script is present in the ROOT/bin folder of this project, use this as it wraps packer in 
some sanity checks.

```
    $ bin/packer.sh build ec2.json
    $ bin/packer.sh build ec2.json -only=ubuntu-1604-1  # only build the ubuntu template
```
