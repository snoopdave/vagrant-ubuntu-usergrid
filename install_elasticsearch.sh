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

wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -

cd /etc/apt/sources.list.d
cat >> elasticsearch.sources.list << EOF
deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main
EOF
apt-get update
apt-get --force-yes -y install elasticsearch

cat >> /etc/default/elasticsearch << EOF
ES_HEAP_SIZE=300m
MAX_OPEN_FILES=65535
MAX_LOCKED_MEMORY=unlimited
EOF

/etc/init.d/elasticsearch stop

update-rc.d elasticsearch defaults 95 10
groovy /vagrant/config_elasticsearch.groovy > /etc/elasticsearch/elasticsearch.yml

/etc/init.d/elasticsearch start