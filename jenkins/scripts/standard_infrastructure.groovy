node('jenkins-linux-slave') {
    currentBuild.displayName = "account: ${ACCOUNT_ID}"
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

    withEnv(["REGION=${REGION}", "ENVIRONMENT=${ENVIRONMENT}"]) {
       stage ('init') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              terraform init -backend-config="key=terraform-state/standard-${ENVIRONMENT}.tfstate"
              ''')
          }
       }
       stage ('get') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              terraform get
              ''')
          }
       }
       stage ('plan') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              terraform plan -var-file="${ENVIRONMENT}/config.tfvars"
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
              terraform apply -var-file="${ENVIRONMENT}/config.tfvars"
              ''')
          }
       }
       stage ('outputs') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              terraform output -json > ${ENVIRONMENT}/${ENVIRONMENT}-outputs.json
              aws s3 cp ${ENVIRONMENT}/standard-${ENVIRONMENT}-outputs.json s3://adidas-terraform/terraform-outputs/
              ''')
          }
       }
    }
}