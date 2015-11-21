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

# purge old Node.js, add repo for new Node.js
apt-get purge nodejs npm
curl -sL https://deb.nodesource.com/setup | sudo bash -

# install what we need for building and running Usergrid Stack and Portal
apt-get -y install tomcat7 unzip git maven nodejs python-software-properties python g++ make
/etc/init.d/tomcat7 stop

# this is necessary because the portal build still uses "node" in scripts
ln -s /usr/bin/nodejs /usr/bin/node

# fetch usergrid code in our home dir
cd /home/vagrant
git clone https://git-wip-us.apache.org/repos/asf/usergrid.git usergrid

# build Usergrid stack, deploy it to Tomcat and then configure it
cd usergrid/stack
git checkout 1.x
mvn -DskipTests=true install
cp rest/src/test/resources/log4j.properties /usr/share/tomcat7/lib/
cd rest/target
rm -rf /var/lib/tomcat7/webapps/*
cp -r ROOT.war /var/lib/tomcat7/webapps
mkdir -p /usr/share/tomcat7/lib 
cd /vagrant
groovy config_usergrid.groovy > /usr/share/tomcat7/lib/usergrid-custom.properties 

# configure Tomcat memory and and hook up Log4j because Usergrid uses it 
cat >> /usr/share/tomcat7/bin/setenv.sh << EOF
export JAVA_OPTS="-Xmx512m -Dlog4j.configuration=file:///usr/share/tomcat7/lib/log4j.properties -Dlog4j.debug=false"
EOF
chmod +x /usr/share/tomcat7/bin/setenv.sh
cp /home/vagrant/usergrid/stack/rest/src/test/resources/log4j.properties /usr/share/tomcat7/lib/

# build and deploy Usergrid Portal to Tomcat
npm install karma-phantomjs-launcher --save-dev

cd /home/vagrant/usergrid/portal
./build.sh 
cd dist
mkdir /var/lib/tomcat7/webapps/portal
cp -r usergrid-portal/* /var/lib/tomcat7/webapps/portal
sed -i.bak "s/http\:\/\/localhost/http\:\/\/${PUBLIC_HOSTNAME}/" /var/lib/tomcat7/webapps/portal/config.js 

# go!
/etc/init.d/tomcat7 start

sleep 10

# init usergrid
curl http://localhost:8080/system/database/setup -u superuser:test
curl http://localhost:8080/system/superuser/setup -u superuser:test

