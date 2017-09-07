node('jenkins-linux-slave') {
    currentBuild.displayName = "account: ${ACCOUNT_ID}"
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
       stage ('init') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/management-infrastructure
              terraform init -backend-config="key=terraform-state/management-${ENVIRONMENT}.tfstate"
              ''')
          }
       }
       stage ('get') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/management-infrastructure
              terraform get
              ''')
          }
       }
       stage ('plan') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/management-infrastructure
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
              cd infrastructure/terraform/infrastructure/management-infrastructure
              terraform apply -var-file="${ENVIRONMENT}/config.tfvars"
              ''')
          }
       }
       stage ('outputs') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/management-infrastructure
              terraform outputs terraform output -json > ${ENVIRONMENT}/outputs.json
              aws s3 cp ${ENVIRONMENT}/outputs.json s3://terraform-outputs/
              ''')
          }
       }
    }
}