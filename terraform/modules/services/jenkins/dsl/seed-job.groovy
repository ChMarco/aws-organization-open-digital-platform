import jenkins.model.*

def jobName = "SeedJob"

def git_url = System.getenv('SEEDJOB_GIT')
def svn_url = System.getenv('SEEDJOB_SVN')

def scm = '''<scm class="hudson.scm.NullSCM"/>'''

if ( git_url ) {
  scm = """\
    <scm class="hudson.plugins.git.GitSCM">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url><![CDATA[${git_url}]]></url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>**</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="list"/>
      <extensions/>
    </scm>
  """
} else if ( svn_url ) {
  scm = """\
    <scm class='hudson.scm.SubversionSCM'>
      <locations>
        <hudson.scm.SubversionSCM_-ModuleLocation>
          <remote><![CDATA[${svn_url}]]></remote>
          <local>.</local>
          <depthOption>infinity</depthOption>
        </hudson.scm.SubversionSCM_-ModuleLocation>
      </locations>
      <workspaceUpdater class='hudson.scm.subversion.UpdateUpdater'></workspaceUpdater>
      <excludedRegions></excludedRegions>
      <includedRegions></includedRegions>
      <excludedUsers></excludedUsers>
      <excludedCommitMessages></excludedCommitMessages>
      <excludedRevprop></excludedRevprop>
    </scm>
  """
}

def configXml = """\
<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description>Create Jenkins jobs from DSL groovy files</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.sonyericsson.rebuild.RebuildSettings plugin="rebuild@1.25">
      <autoRebuild>false</autoRebuild>
      <rebuildDisabled>false</rebuildDisabled>
    </com.sonyericsson.rebuild.RebuildSettings>
    <hudson.plugins.throttleconcurrents.ThrottleJobProperty plugin="throttle-concurrents@2.0.1">
      <maxConcurrentPerNode>0</maxConcurrentPerNode>
      <maxConcurrentTotal>0</maxConcurrentTotal>
      <categories class="java.util.concurrent.CopyOnWriteArrayList"/>
      <throttleEnabled>false</throttleEnabled>
      <throttleOption>project</throttleOption>
      <limitOneJobWithMatchingParams>false</limitOneJobWithMatchingParams>
      <paramsToUseForLimit></paramsToUseForLimit>
    </hudson.plugins.throttleconcurrents.ThrottleJobProperty>
  </properties>
  <scm class="hudson.plugins.git.GitSCM" plugin="git@3.5.1">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <url>git@github.com:contino/aws-terraform-open-digital-platform-template-account.git</url>
        <credentialsId>adidas-jenkins</credentialsId>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>*/terraform</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions/>
  </scm>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <javaposse.jobdsl.plugin.ExecuteDslScripts plugin="job-dsl@1.65">
      <targets>terraform/modules/services/jenkins/dsl/jobs/*.groovy
terraform/modules/services/jenkins/dsl/views/*.groovy</targets>
      <usingScriptText>false</usingScriptText>
      <sandbox>false</sandbox>
      <ignoreExisting>false</ignoreExisting>
      <ignoreMissingFiles>false</ignoreMissingFiles>
      <failOnMissingPlugin>false</failOnMissingPlugin>
      <unstableOnDeprecation>false</unstableOnDeprecation>
      <removedJobAction>IGNORE</removedJobAction>
      <removedViewAction>IGNORE</removedViewAction>
      <removedConfigFilesAction>IGNORE</removedConfigFilesAction>
      <lookupStrategy>SEED_JOB</lookupStrategy>
    </javaposse.jobdsl.plugin.ExecuteDslScripts>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>
""".stripIndent()


if (!Jenkins.instance.getItem(jobName)) {
  def xmlStream = new ByteArrayInputStream( configXml.getBytes() )
  try {
    def seedJob = Jenkins.instance.createProjectFromXML(jobName, xmlStream)
  } catch (ex) {
    println "ERROR: ${ex}"
    println configXml.stripIndent()
  }
}