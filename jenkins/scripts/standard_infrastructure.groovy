node {
    currentBuild.displayName = "account: ${ACCOUNT_ID}"
    currentBuild.description = "Provisioning Management Infrastructure"


    dir('infrastructure') {
        checkout([
            $class: 'GitSCM', branches: [[name: '*/${BRANCH}']],
            userRemoteConfigs: [[
                credentialsId: props['env_JENKINS_USER'],
                refspec: '+refs/heads/*:refs/remotes/origin/* +refs/tags/*:refs/remotes/origin/tags/*',
                url: 'https://github.com/contino/aws-terraform-open-digital-platform-template-account.git'
            ]]
        ])
    }

    withEnv(["REGION=${REGION}", "ENVIRONMENT=${ENVIRONMENT}"]) {
       stage ('init') {
          ansiColor('xterm') {
              sh ('''
              cd aws-terraform-open-digital-platform-template-account/terraform/infrastructure/
              terraform init -backend-config="key=terraform-state/management-${ENVIRONMENT}.tfstate"
              ''')
          }
       }
       stage ('get') {
          ansiColor('xterm') {
              sh ('''
              PATH=/opt/terraform-0.8.4/:${PATH}
              cd aws-terraform-open-digital-platform-template-account/terraform/infrastructure/standard-infrastructure
              terraform get -var-file="${ENVIRONMENT}/config.tfvars"
              ''')
          }
       }
       stage ('plan') {
          ansiColor('xterm') {
              sh ('''
              cd aws-terraform-open-digital-platform-template-account/terraform/infrastructure/standard-infrastructure
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
              cd aws-terraform-open-digital-platform-template-account/terraform/infrastructure/standard-infrastructure
              terraform apply -var-file="${ENVIRONMENT}/config.tfvars"
              ''')
          }
       }
    }
}