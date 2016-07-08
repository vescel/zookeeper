#!/bin/bash

export MYID_FILE="/opt/zookeeper/myid"
if [ -e $MYID_FILE ]; then
    export ZK_SERVER_ID=$(<$MYID_FILE)
    export ZK_SERVER_KEY="server${ZK_SERVER_ID}"

    echo "cleanup removing zookeeper key from consul:${ZK_SERVER_KEY}"

    curl -s -X DELETE http://$CONSUL:8500/v1/kv/zookeeper/$ZK_SERVER_KEY
fi
