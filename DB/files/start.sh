#!/bin/bash

until [[ $SEED1IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ && 
         $SEED2IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
do
   SEED1IP=`curl -s http://rancher-metadata/2015-12-19/services/DB/containers/0/primary_ip`
   SEED2IP=`curl -s http://rancher-metadata/2015-12-19/services/DB/containers/1/primary_ip`
done
CASSANDRA_SEEDS="$SEED1IP,$SEED2IP"

MYIP=`curl http://rancher-metadata/2015-12-19/self/container/primary_ip`

CASSANDRA_CLUSTER_NAME=RETO4 \
CASSANDRA_LISTEN_ADDRESS="$MYIP" \
CASSANDRA_SEEDS="$CASSANDRA_SEEDS" \
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
