node('jenkins-linux-slave') {
    currentBuild.displayName = "account: ${ACCOUNT_ID}-${STACK}-${ENVIRONMENT}"
    currentBuild.description = "Provisioning Standard Infrastructure"


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

    withEnv(["REGION=${STATE_BUCKET_REGION}", "ENVIRONMENT=${ENVIRONMENT}"]) {
       stage ('fetch_credentials') {
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
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              ./stack.sh ${ACCOUNT_ID} ${ACCOUNT_PROFILE} ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} ${STACK} init
              ''')
          }
       }
       stage ('get') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              ./stack.sh ${ACCOUNT_ID} ${ACCOUNT_PROFILE} ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} ${STACK} get
              ''')
          }
       }
       stage ('plan') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              ./stack.sh ${ACCOUNT_ID} ${ACCOUNT_PROFILE} ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} ${STACK} plan
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
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              ./stack.sh ${ACCOUNT_ID} ${ACCOUNT_PROFILE} ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} ${STACK} apply
              ''')
          }
       }
       stage ('outputs') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              ./stack.sh ${ACCOUNT_ID} ${ACCOUNT_PROFILE} ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} ${STACK} output
              ''')
          }
       }
    }
}