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

# VagrantFile passes in hostname as argument 1
export PUBLIC_HOSTNAME=$1

echo " "
echo "--------------------------------------------------------------------------"
echo "Installing OpenJDK"
echo "--------------------------------------------------------------------------"
echo " "

apt-get -y install software-properties-common
add-apt-repository -y ppa:openjdk-r/ppa
apt-get update
apt-get -y install vim curl openjdk-8-jdk 

# ensure Java 8 is the default
# see also: http://ubuntuhandbook.org/index.php/2015/01/install-openjdk-8-ubuntu-14-04-12-04-lts/
update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java" 1
echo "1" | sudo update-alternatives --config java

# create a startup file for all shells
cat >/etc/profile.d/usergrid-env.sh <<EOF
alias sudo='sudo -E'
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
export PUBLIC_HOSTNAME=$PUBLIC_HOSTNAME
EOF

# setup login environment
source /etc/profile.d/usergrid-env.sh 

pushd /vagrant
chmod +x *.sh

./install_cassandra.sh
./install_elasticsearch.sh
./install_usergrid.sh

