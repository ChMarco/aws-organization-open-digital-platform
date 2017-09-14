pipelineJob('infrastructure/tf_account_infrastructure') {
    parameters {
      stringParam('ACCOUNT_ID', '', 'AWS Account ID')
      stringParam('ACCOUNT_PROFILE', 'default', 'AWS Account PROFILE')
      stringParam('AWS_ACCESS_KEY', '', 'AWS acces key')
      stringParam('AWS_SECRET_ACCESS_KEY', '', 'AWS secret access key')
      stringParam('STATE_BUCKET', '', 'S3 Bucket for TF State')
      stringParam('STATE_BUCKET_REGION', 'eu-west-1', 'AWS Region')
      stringParam('BRANCH', 'develop', 'Repo Branch')
    }
    definition {
      cps {
          script(readFileFromWorkspace('jenkins/scripts/account_infrastructure.groovy'))
      }
    }
}
