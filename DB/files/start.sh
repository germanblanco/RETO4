#!/bin/sh

MYIP=`ip a | grep "global eth0" | awk '{print $2}' | sed "s/\/..//"`
sed -i.bak "s/cluster_name: 'Test Cluster'/cluster_name: 'RETO4'/" /etc/cassandra/cassandra.yaml
sed -i.bak "s/cluster_name: 'Test Cluster'/cluster_name: 'RETO4'/" /etc/cassandra/cassandra.yaml

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
