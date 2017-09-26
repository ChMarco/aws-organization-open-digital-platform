pipelineJob('infrastructure/tf_standard_infrastructure') {
    parameters {
      stringParam('ACCOUNT_ID', '', 'AWS Account ID')
      stringParam('AWS_ACCESS_KEY', '', 'AWS acces key')
      stringParam('AWS_SECRET_ACCESS_KEY', '', 'AWS secret access key')
      stringParam('ENVIRONMENT', 'test', 'Infrastructure Environment')
      stringParam('REGION', 'eu-west-1', 'AWS Region to deploy to')
      stringParam('STATE_BUCKET', '', 'S3 Bucket for TF State')
      stringParam('STATE_BUCKET_REGION', 'eu-west-1', 'AWS Region')
      stringParam('BRANCH', 'develop', 'Repo Branch')
      stringParam('STACK', 'demo', 'Stack to deploy')
      stringParam('VPC_SHORTNAME', '', 'Name of VPC')
      stringParam('VPC_DESCRIPTION', '', 'Description of VPC')
      stringParam('VPC_CIDR', '', 'Cidr Block of VPC')
      stringParam('MANAGEMENT_VPC_ID', '', 'ID of Management VPC')
      stringParam('MANAGEMENT_VPC_CIDR', '', 'Cidr Block of Management VPC')
      stringParam('MANAGEMENT_VPC_SHORTNAME', '', 'Shortname of Management VPC')
      stringParam('DMZ_SUBNET_CIDR', '', 'Cidr Block of DMZ Subnets; seperated by comma.')
      stringParam('PUBLIC_SUBNET_CIDR', '', 'Cidr Block of Public Subnets; seperated by comma.')
      stringParam('PRIVATE_SUBNET_CIDR', '', 'Cidr Block of Private Subnets; seperated by comma.')
      stringParam('JENKINS_IMAGE_TAG', '', 'Jenkins Docker Image Tag')
      stringParam('SSH_WEB_WHITELIST', '', 'IPs allowed SSH and Web access')
      stringParam('TAG_PROJECT_NAME', '', 'Project Name')
      stringParam('TAG_COST_CENTER', '', 'Cost Centre')
      stringParam('TAG_APP_OPERATIONS_OWNER', '', 'App Operations Owner')
      stringParam('TAG_SYSTEM_OWNER', '', 'System Owner')
      stringParam('TAG_BUDGET_OWNER', '', 'Budget Owner')
    }
    definition {
      cps {
          script(readFileFromWorkspace('terraform/modules/services/jenkins/dsl/scripts/standard_infrastructure.groovy'))
      }
    }
}
