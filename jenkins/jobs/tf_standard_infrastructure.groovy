pipelineJob('tf_management_infrastructure') {
    parameters {
      stringParam('ACCOUNT_ID', '', 'AWS Account ID')
      stringParam('ACCOUNT_ACCESS_KEY', '', 'AWS Account Root User Access Key')
      stringParam('ACCOUNT_SECRET_KEY', '', 'AWS Account Root User Secret Key')
      stringParam('ENVIRONMENT', 'test', 'Infrastructure Environment')
      stringParam('REGION', 'eu-west-1', 'AWS Region')
      stringParam('BRANCH', 'develop', 'Repo Branch')
    }
    definition {
      cps {
          script(readFileFromWorkspace('jenkins/scripts/standard_infrastructure.groovy'))
      }
    }
}
