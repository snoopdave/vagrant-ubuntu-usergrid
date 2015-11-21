
//-----------------------------------------------------------------------------
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//-----------------------------------------------------------------------------

String hostName  = (String)System.getenv().get("PUBLIC_HOSTNAME")

def baseUrl      = "http://${hostName}:8080"
def clusterName  = "usergrid"

def superUserEmail     = "superuser@example.com"
def testAdminUserEmail = "testuser@example.com"

def usergridConfig = """
######################################################
# Minimal Usergrid configuration properties for local Tomcat and Cassandra 
#

cassandra.url=${hostName}:9160
cassanrda.cluster=${clusterName}
cassandra.keyspace.strategy.options.replication_factor=1
cassandra.keyspace.strategy=org.apache.cassandra.locator.SimpleStrategy

# These settings seem to cause problems at startup time
#cassandra.keyspace.strategy=org.apache.cassandra.locator.NetworkTopologyStrategy
#cassandra.writecl=LOCAL_QUORUM
#cassandra.readcl=LOCAL_QUORUM


######################################################
# Custom mail transport 

mail.transport.protocol=smtps
mail.smtps.host=smtp.gmail.com
mail.smtps.port=465
mail.smtps.auth=true
mail.smtps.quitwait=false

# CAUTION: THERE IS A PASSWORD HERE!
mail.smtps.username=usergridtest@gmail.com
mail.smtps.password=

######################################################
# Admin and test user setup

usergrid.sysadmin.login.allowed=true
usergrid.sysadmin.login.name=superuser
usergrid.sysadmin.login.password=test
usergrid.sysadmin.login.email=${superUserEmail}

usergrid.sysadmin.email=${superUserEmail}
usergrid.sysadmin.approve.users=true
usergrid.sysadmin.approve.organizations=true

# Base mailer account - default for all outgoing messages
usergrid.management.mailer=Admin <${superUserEmail}>

usergrid.setup-test-account=true

usergrid.test-account.app=test-app
usergrid.test-account.organization=test-organization
usergrid.test-account.admin-user.username=test
usergrid.test-account.admin-user.name=Test User
usergrid.test-account.admin-user.email=${testAdminUserEmail}
usergrid.test-account.admin-user.password=test

######################################################
# Auto-confirm and sign-up notifications settings

usergrid.management.admin_users_require_confirmation=false
usergrid.management.admin_users_require_activation=false

usergrid.management.organizations_require_activation=false
usergrid.management.notify_sysadmin_of_new_organizations=true
usergrid.management.notify_sysadmin_of_new_admin_users=true

######################################################
# URLs

# Redirect path when request come in for TLD
usergrid.redirect_root=${baseUrl}/status

usergrid.view.management.organizations.organization.activate=${baseUrl}/accounts/welcome
usergrid.view.management.organizations.organization.confirm=${baseUrl}/accounts/welcome

usergrid.view.management.users.user.activate=${baseUrl}/accounts/welcome
usergrid.view.management.users.user.confirm=${baseUrl}/accounts/welcome

usergrid.admin.confirmation.url=${baseUrl}/management/users/%s/confirm
usergrid.user.confirmation.url=${baseUrl}/%s/%s/users/%s/confirm

usergrid.organization.activation.url=${baseUrl}/management/organizations/%s/activate
usergrid.admin.activation.url=${baseUrl}/management/users/%s/activate
usergrid.user.activation.url=${baseUrl}%s/%s/users/%s/activate

usergrid.admin.resetpw.url=${baseUrl}/management/users/%s/resetpw
usergrid.user.resetpw.url=${baseUrl}/%s/%s/users/%s/resetpw
"""
println usergridConfig 