#!/bin/sh

untilsuccessful() {
  "$@"
  while [ $? -ne 0 ]
  do
    sleep 1
    "$@"
  done
}

chown riak:riak /var/lib/riak /var/log/riak
chmod 755 /var/lib/riak /var/log/riak

echo 'search = on' >> /etc/riak/riak.conf
echo 'storage_backend = leveldb' >> /etc/riak/riak.conf
echo 'listener.http.internal = 0.0.0.0:8098' >> /etc/riak/riak.conf
echo 'listener.protobuf.internal = 0.0.0.0:8087' >> /etc/riak/riak.conf
echo 'ssl.certfile = /vagrant/certs/server.crt' >> /etc/riak/riak.conf
echo 'ssl.keyfile = /vagrant/certs/server.key' >> /etc/riak/riak.conf
echo 'ssl.cacertfile = /vagrant/certs/ca.crt' >> /etc/riak/riak.conf
echo 'buckets.default.allow_mult = true' >> /etc/riak/riak.conf
echo 'tls_protocols.tlsv1.1 = on' >> /etc/riak/riak.conf
echo 'check_crl = off' >> /etc/riak/riak.conf

ulimit -n 65536
ulimit -n

riak start
untilsuccessful riak-admin test &>/dev/null

riak-admin bucket-type create counters '{"props":{"datatype":"counter", "allow_mult":true}}'
riak-admin bucket-type create other_counters '{"props":{"datatype":"counter", "allow_mult":true}}'
riak-admin bucket-type create maps '{"props":{"datatype":"map", "allow_mult":true}}'
riak-admin bucket-type create sets '{"props":{"datatype":"set", "allow_mult":true}}'
riak-admin bucket-type create yokozuna '{"props":{}}'

riak-admin security add-user user password=password
riak-admin security add-user certuser

riak-admin security add-source user 0.0.0.0/0 password
riak-admin security add-source certuser 0.0.0.0/0 certificate

riak-admin security grant riak_kv.get,riak_kv.put,riak_kv.delete,riak_kv.index,riak_kv.list_keys,riak_kv.list_buckets,riak_core.get_bucket,riak_core.set_bucket,riak_core.get_bucket_type,riak_core.set_bucket_type,search.admin,search.query,riak_kv.mapreduce on any to user

sleep 10

riak-admin bucket-type activate other_counters
riak-admin bucket-type activate counters
riak-admin bucket-type activate maps
riak-admin bucket-type activate sets
riak-admin bucket-type activate yokozuna

while true;do true; done
