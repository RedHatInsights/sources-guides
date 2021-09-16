#!/bin/bash

source config.sh

cd $KAFKA_DIR

# Listening on IPV4, but ruby-kafka doesn't support it (keeping disabled)
#export KAFKA_OPTS="-Djava.net.preferIPv4Stack=True"

operation=$1
if [ "$operation" = "start" ]; then
	bin/zookeeper-server-start.sh config/zookeeper.properties &
	sleep 10
	bin/kafka-server-start.sh config/server.properties 
	#bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --topic topological_inventory-persister --partitions 500 --config max.message.bytes=10000000	
	#bin/kafka-topics.sh --alter --zookeeper localhost:2181 --replication-factor 1 --topic topological_inventory-persister --partitions 500 --config max.message.bytes=10000000	
elif [ "$operation" = "fast-forget" ]; then
	bin/kafka-configs.sh --zookeeper localhost:2181 --alter --entity-type topics --entity-name platform.topological-inventory.persister --add-config retention.ms=1000
	bin/kafka-configs.sh --zookeeper localhost:2181 --alter --entity-type topics --entity-name platform.topological-inventory.operations-openshift --add-config retention.ms=1000
elif [ "$operation" = "rm-fast-forget" ]; then
	bin/kafka-configs.sh --zookeeper localhost:2181 --alter --entity-type topics --entity-name platform.topological-inventory.persister --delete-config retention.ms	
	bin/kafka-configs.sh --zookeeper localhost:2181 --alter --entity-type topics --entity-name platform.topological-inventory.operations-openshift --delete-config retention.ms
elif [ "$operation" = "stop" ]; then
	bin/kafka-server-stop.sh
	bin/zookeeper-server-stop.sh
else
	echo "Usage: kafka.sh <operation>"
	echo "--- Operation:---"
	echo "start -> starts server"
	echo "stop -> stops server"
	echo "fast-forget -> clears topics topological_inventory-persister and platform.topological-inventory.operations-openshift"
	echo "rm-fast-forget -> sets message remember time to default value for topic topological_inventory-persister"
fi	

