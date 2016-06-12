#!/bin/bash

until [[ $SEED1IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ && 
         $SEED2IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
do
   SEED1IP=`curl -s http://rancher-metadata/2015-12-19/services/DB/containers/0/primary_ip`
   SEED2IP=`curl -s http://rancher-metadata/2015-12-19/services/DB/containers/1/primary_ip`
done

MYIP=`curl http://rancher-metadata/2015-12-19/self/container/primary_ip`

sed -i.bak "s/cluster_name: 'Test Cluster'/cluster_name: 'RETO4'/" /etc/cassandra/cassandra.yaml
sed -i.bak "s/seeds: .*/seeds: \"$SEED1IP,$SEED2IP\"/" /etc/cassandra/cassandra.yaml
sed -i.bak "s/listen_address: .*/listen_address: \"$MYIP\"/" /etc/cassandra/cassandra.yaml
sed -i.bak "s/broadcast_address: .*/broadcast_address: \"$MYIP\"/" /etc/cassandra/cassandra.yaml
sed -i.bak "s/broadcast_rpc_address: .*/broadcast_rpc_address: \"$MYIP\"/" /etc/cassandra/cassandra.yaml

sed -i.bak "16,36d" /docker-entrypoint.sh

cat /etc/cassandra/cassandra.yaml

/docker-entrypoint.sh cassandra -f &
until cqlsh -e "describe keyspace system;"
do
  echo "Waiting for Cassandra..."
  sleep 3
done
echo "Cassandra is UP!!"
cqlsh -f /root/create_table.cql
echo "Keyspace and table created."
wait %1
