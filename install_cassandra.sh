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
echo "Installing Cassandra"
echo "--------------------------------------------------------------------------"
echo " "

# install and stop Cassandra
cat >> /etc/apt/sources.list.d/cassandra.sources.list << EOF
deb http://www.apache.org/dist/cassandra/debian 12x main
EOF
apt-get update
apt-get --force-yes -y install libcap2
apt-get --force-yes -y install cassandra
/etc/init.d/cassandra stop

# Set Cassandra heap size to something small
sed -i.bak "s/#MAX_HEAP_SIZE=\"4G\"/MAX_HEAP_SIZE=\"450m\"/" /etc/cassandra/cassandra-env.sh
sed -i.bak "s/#HEAP_NEWSIZE=\"800M\"/HEAP_NEWSIZE=\"100m\"/" /etc/cassandra/cassandra-env.sh

mkdir -p /mnt/data/cassandra
chown cassandra /mnt/data/cassandra
cat >> /etc/cassandra/cassandra.yaml << EOF

cluster_name: 'usergrid'
listen_address: ${PUBLIC_HOSTNAME}
seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
      parameters:
          - seeds: "${PUBLIC_HOSTNAME}"
auto_bootstrap: true
initial_token:
hinted_handoff_enabled: true
hinted_handoff_throttle_in_kb: 1024
max_hints_delivery_threads: 2
authenticator: org.apache.cassandra.auth.AllowAllAuthenticator
authorizer: org.apache.cassandra.auth.AllowAllAuthorizer
partitioner: org.apache.cassandra.dht.RandomPartitioner
data_file_directories:
    - /mnt/data/cassandra/data
commitlog_directory: /mnt/data/cassandra/commitlog
disk_failure_policy: stop
key_cache_size_in_mb:
key_cache_save_period: 14400
row_cache_size_in_mb: 0
row_cache_save_period: 0
row_cache_provider: SerializingCacheProvider
saved_caches_directory: /mnt/data/cassandra/saved_caches
commitlog_sync: periodic
commitlog_sync_period_in_ms: 10000
commitlog_segment_size_in_mb: 32
flush_largest_memtables_at: 0.75
reduce_cache_sizes_at: 0.85
reduce_cache_capacity_to: 0.6
concurrent_reads: 32
concurrent_writes: 32
memtable_flush_queue_size: 4
trickle_fsync: false
trickle_fsync_interval_in_kb: 10240
storage_port: 7000
ssl_storage_port: 7001
rpc_address: 0.0.0.0
start_native_transport: false
native_transport_port: 9042
start_rpc: true
rpc_port: 9160
rpc_keepalive: true
rpc_server_type: sync
thrift_framed_transport_size_in_mb: 15
thrift_max_message_length_in_mb: 16
incremental_backups: false
snapshot_before_compaction: false
auto_snapshot: true
column_index_size_in_kb: 64
in_memory_compaction_limit_in_mb: 64
multithreaded_compaction: false
compaction_throughput_mb_per_sec: 16
compaction_preheat_key_cache: true
read_request_timeout_in_ms: 10000
range_request_timeout_in_ms: 10000
write_request_timeout_in_ms: 10000
truncate_request_timeout_in_ms: 60000
request_timeout_in_ms: 10000
cross_node_timeout: false
endpoint_snitch: SimpleSnitch
dynamic_snitch_update_interval_in_ms: 100 
dynamic_snitch_reset_interval_in_ms: 600000
dynamic_snitch_badness_threshold: 0.1
request_scheduler: org.apache.cassandra.scheduler.NoScheduler
index_interval: 128
server_encryption_options:
    internode_encryption: none
    keystore: conf/.keystore
    keystore_password: cassandra
    truststore: conf/.truststore
    truststore_password: cassandra
client_encryption_options:
    enabled: false
    keystore: conf/.keystore
    keystore_password: cassandra
internode_compression: all

EOF

/etc/init.d/cassandra start
