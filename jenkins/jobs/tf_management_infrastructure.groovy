pipelineJob('tf_management_infrastructure') {
    parameters {
      stringParam('ACCOUNT_ID', '', 'AWS Account ID')
      stringParam('ACCOUNT_PROFILE', '', 'AWS Account PROFILE')
      stringParam('ENVIRONMENT', 'test', 'Infrastructure Environment')
      stringParam('STATE_BUCKET', '', 'S3 Bucket for TF State')
      stringParam('STATE_BUCKET_REGION', 'eu-west-1', 'AWS Region')
      stringParam('BRANCH', 'develop', 'Repo Branch')
    }
    definition {
      cps {
          script(readFileFromWorkspace('jenkins/scripts/management_infrastructure.groovy'))
      }
    }
}
