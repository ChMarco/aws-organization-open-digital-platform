pipelineJob('infrastructure/tf_account_infrastructure') {
    parameters {
      stringParam('ACCOUNT_ID', '', 'AWS Account ID')
      stringParam('AWS_ACCESS_KEY', '', 'AWS acces key')
      stringParam('AWS_SECRET_ACCESS_KEY', '', 'AWS secret access key')
      stringParam('STATE_BUCKET', '', 'S3 Bucket for TF State')
      stringParam('STATE_BUCKET_REGION', 'eu-west-1', 'AWS Region')
      stringParam('BRANCH', 'terraform', 'Repo Branch')
    }
    definition {
      cps {
          script(readFileFromWorkspace('scripts/account_infrastructure.groovy'))
      }
    }
}
