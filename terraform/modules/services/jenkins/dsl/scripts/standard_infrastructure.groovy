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

    withEnv([
    "REGION=${REGION}", "ENVIRONMENT=${ENVIRONMENT}", "TF_VAR_account_id=${ACCOUNT_ID}", "TF_VAR_stack=${STACK}",
    "TF_VAR_aws_region=${REGION}", "TF_VAR_deploy_environment=${ENVIRONMENT}", "TF_VAR_vpc_shortname=${VPC_SHORTNAME}",
    "TF_VAR_vpc_description=${VPC_DESCRIPTION}", "TF_VAR_vpc_cidr_block=${VPC_CIDR}", "TF_VAR_dmz_subnet_cidr_blocks=${DMZ_SUBNET_CIDR}",
    "TF_VAR_public_subnet_cidr_blocks=${PUBLIC_SUBNET_CIDR}", "TF_VAR_private_subnet_cidr_blocks=${PRIVATE_SUBNET_CIDR}",
    "TF_VAR_jenkins_image_tag=${JENKINS_IMAGE_TAG}", "TF_VAR_management_keypair=${MANAGEMENT_KEYPAIR}",
    "TF_VAR_ssh_web_whitelist=${SSH_WEB_WHITELIST}", "TF_VAR_tag_project_name=${TAG_PROJECT_NAME}",
    "TF_VAR_tag_cost_center=${TAG_COST_CENTER}", "TF_VAR_tag_environment=${ENVIRONMENT}",
    "TF_VAR_tag_app_operations_owner=${TAG_APP_OPERATIONS_OWNER}", "TF_VAR_tag_system_owner=${TAG_SYSTEM_OWNER}",
    "TF_VAR_tag_budget_owner=${TAG_BUDGET_OWNER}"
    ]) {
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
              ./stack.sh ${ACCOUNT_ID} default ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} ${STACK} init
              ''')
          }
       }
       stage ('get') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              ./stack.sh ${ACCOUNT_ID} default ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} ${STACK} get
              ''')
          }
       }
       stage ('plan') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              ./stack.sh ${ACCOUNT_ID} default ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} ${STACK} plan
              ''')
          }
       }
       stage ('plan-confirmation') {
          timeout (time: 5, unit: 'MINUTES') {
              input("Is plan doing what you expect?")
          }
       }
       stage ('apply') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              ./stack.sh ${ACCOUNT_ID} default ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} ${STACK} apply
              ''')
          }
       }
       stage ('outputs') {
          ansiColor('xterm') {
              sh ('''
              cd infrastructure/terraform/infrastructure/standard-infrastructure
              ./stack.sh ${ACCOUNT_ID} default ${ENVIRONMENT} ${STATE_BUCKET} ${STATE_BUCKET_REGION} ${STACK} output
              ''')
          }
       }
    }
}