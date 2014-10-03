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

if [ "$#" -ne 3 ]; then
    echo "Must specify IP address, a list of DB servers IPs and the Cassandra replication factor"
fi
echo $1
export PUBLIC_HOSTNAME=$1

apt-get update
chmod +x *.sh

# install essential stuff
apt-get -y install vim curl groovy

# install Java 7 and set it as default Java
# http://askubuntu.com/questions/121654/how-to-set-default-java-version
apt-get -y install openjdk-7-jdk
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/java-1.7.0-openjdk-amd64/bin/java" 1
echo "1" | sudo update-alternatives --config java

# create a startup file for all shells
cat >/etc/profile.d/usergrid-env.sh <<EOF
alias sudo='sudo -E'
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64/jre
export PUBLIC_HOSTNAME=$PUBLIC_HOSTNAME
EOF

# setup login environment
source /etc/profile.d/usergrid-env.sh 

pushd /vagrant
./install_cassandra.sh
./install_elasticsearch.sh
./install_usergrid.sh
