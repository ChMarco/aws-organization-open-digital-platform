job('adidas.jobs-setup.odp') {
  scm {
    git {
      branch(job_dsl_BRANCH)
      remote {
        credentials('adidas-jenkins')
        refspec: '+refs/heads/*:refs/remotes/origin/* +refs/tags/*:refs/remotes/origin/tags/*',
        url: 'git@github.com:contino/aws-terraform-open-digital-platform-template-account.git'
      }
    }
  }
  wrappers {
    colorizeOutput()
  }
  steps {
    dsl {
      external(['jenkins/views/infrastructure*.groovy', 'jenkins/jobs/*.groovy'])
    }
  }
}
