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
echo "Installing ElasticSearch"
echo "--------------------------------------------------------------------------"
echo " "

apt-get --force-yes -y install elasticsearch

cat >> /etc/default/elasticsearch << EOF
ES_HEAP_SIZE=450m
MAX_OPEN_FILES=65535
MAX_LOCKED_MEMORY=unlimited
EOF

cat >> /etc/elasticsearch/elasticsearch.yml << EOF
cluster.name: elasticsearch
EOF

/etc/init.d/elasticsearch stop

update-rc.d elasticsearch defaults 95 10

/etc/init.d/elasticsearch start

sleep 5

# setup for single node usage
curl -XPUT 'localhost:9200/_settings' -d '{"index" : { "number_of_replicas" : 0}}'

