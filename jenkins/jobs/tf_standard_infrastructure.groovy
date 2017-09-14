pipelineJob('infrastructure/tf_standard_infrastructure') {
    parameters {
      stringParam('ACCOUNT_ID', '', 'AWS Account ID')
      stringParam('ACCOUNT_PROFILE', 'adidas', 'AWS Account PROFILE')
      stringParam('AWS_ACCESS_KEY', '', 'AWS acces key')
      stringParam('AWS_SECRET_ACCESS_KEY', '', 'AWS secret access key')
      stringParam('ENVIRONMENT', 'test', 'Infrastructure Environment')
      stringParam('STATE_BUCKET', '', 'S3 Bucket for TF State')
      stringParam('STATE_BUCKET_REGION', 'eu-west-1', 'AWS Region')
      stringParam('STACK', 'demo', 'Stack to deploy')
      stringParam('BRANCH', 'develop', 'Repo Branch')
    }
    definition {
      cps {
          script(readFileFromWorkspace('jenkins/scripts/standard_infrastructure.groovy'))
      }
    }
}
