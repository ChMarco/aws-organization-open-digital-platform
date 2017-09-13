node('jenkins-linux-slave') {
    currentBuild.displayName = "account: ${ACCOUNT_ID}-${ENVIRONMENT}"
    currentBuild.description = "Provisioning Management Infrastructure"


    dir('infrastructure') {
        checkout([
            $class: 'GitSCM', branches: [[name: '*/${BRANCH}']],
            userRemoteConfigs: [[
                credentialsId: 'adidas-jenkins',
                refspec: '+refs/heads/*:refs/remotes/origin/* +refs/tags/*:refs/remotes/origin/tags/*',
                url: 'git@github.com:contino/aws-terraform-open-digital-platform-template-account.git'
            ]]
        ])
    }

    withEnv(["REGION=${REGION}", "ENVIRONMENT=${ENVIRONMENT}"]) {
       stage ('creds') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure
              ./aws_creds.sh ${AWS_ACCESS_KEY} ${AWS_SECRET_ACCESS_KEY}
              ''')
          }
       }
       stage ('init') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/management-infrastructure
              ./mgmt.sh ${ACCOUNT_ID} ${ACCOUNT_PROFILE} ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} init
              ''')
          }
       }
       stage ('get') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/management-infrastructure
              ./mgmt.sh ${ACCOUNT_ID} ${ACCOUNT_PROFILE} ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} get
              ''')
          }
       }
       stage ('plan') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/management-infrastructure
              ./mgmt.sh ${ACCOUNT_ID} ${ACCOUNT_PROFILE} ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} plan
              ''')
          }
       }
       stage ('plan-confirmation') {
          timeout (time: 15, unit: 'MINUTES') {
              input("Is plan doing what you expect?")
          }
       }
       stage ('apply') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/management-infrastructure
              ./mgmt.sh ${ACCOUNT_ID} ${ACCOUNT_PROFILE} ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} apply
              ''')
          }
       }
       stage ('outputs') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/management-infrastructure
              ./mgmt.sh ${ACCOUNT_ID} ${ACCOUNT_PROFILE} ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} output
              ''')
          }
       }
    }
}