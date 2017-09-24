import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
def strategy = new hudson.security.FullControlOnceLoggedInAuthorizationStrategy()

hudsonRealm.createAccount("jenkins","changeme")
instance.setSecurityRealm(hudsonRealm)
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)
instance.getAuthorizationStrategy().add(Jenkins.ADMINISTER, 'jenkins')

instance.save()