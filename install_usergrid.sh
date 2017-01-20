#!/bin/bash

#-------------------------------------------------------------------------------
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#-------------------------------------------------------------------------------

echo " "
echo "--------------------------------------------------------------------------"
echo "Installing Usergrid"
echo "--------------------------------------------------------------------------"
echo " "

# Install what we need for building and running Usergrid Stack and Portal
# apt-get -y update
apt-get -y install tomcat7 
/etc/init.d/tomcat7 stop

# Deploy Usergrid stack and portal to Tomcat
cd /vagrant/usergrid

rm -rf /var/lib/tomcat7/webapps/*
cp -r ROOT.war /var/lib/tomcat7/webapps

mkdir -p /usr/share/tomcat7/lib 
cp log4j.properties /usr/share/tomcat7/lib/

# Configure Tomcat memory and and hook up Log4j because Usergrid uses it 
cd /home/vagrant
cat >> /usr/share/tomcat7/bin/setenv.sh << EOF
export JAVA_OPTS="-Xmx450m -Dlog4j.configuration=file:///usr/share/tomcat7/lib/log4j.properties -Dlog4j.debug=false"
EOF
chmod +x /usr/share/tomcat7/bin/setenv.sh

# Deploy Usergrid Portal to Tomcat
cd /vagrant/usergrid
tar xzvf usergrid-portal.tar.gz
cp -r usergrid-portal.2.0.18 /var/lib/tomcat7/webapps/portal
sed -i.bak "s/http\:\/\/localhost/http\:\/\/${PUBLIC_HOSTNAME}/" /var/lib/tomcat7/webapps/portal/config.js 
rm -rf usergrid-portal.2.0.18

# Write Usergrid config
export superUserEmail=superuser@example.com
export testAdminUserEmail=testadmin@example.com
export baseUrl=http://${PUBLIC_HOSTNAME}:8080

cd /vagrant
cat >> /usr/share/tomcat7/lib/usergrid-deployment.properties << EOF

usergrid.cluster_name=usergrid

cassandra.url=${PUBLIC_HOSTNAME}:9160
cassanrda.cluster=usergrid

elasticsearch.cluster_name=elasticsearch
elasticsearch.hosts=${PUBLIC_HOSTNAME}

######################################################
# Admin and test user setup

usergrid.sysadmin.login.allowed=true
usergrid.sysadmin.login.name=superuser
usergrid.sysadmin.login.password=test
usergrid.sysadmin.login.email=${superUserEmail}

usergrid.sysadmin.email=${superUserEmail}
usergrid.sysadmin.approve.users=false
usergrid.sysadmin.approve.organizations=false

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
usergrid.management.notify_sysadmin_of_new_organizations=false
usergrid.management.notify_sysadmin_of_new_admin_users=false

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
EOF



# GO!
/etc/init.d/tomcat7 start

sleep 10

# Init usergrid
curl -X PUT http://localhost:8080/system/database/setup -u superuser:test
curl -X PUT http://localhost:8080/system/database/bootstrap -u superuser:test
curl -X GET http://localhost:8080/system/superuser/setup -u superuser:test
