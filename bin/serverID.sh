#!/bin/bash

function serverID {
    if [ -z "$ZK_SERVER_ID" ]; then
        echo "ZK_SERVER_ID has not been set..."
        export ZK_SERVER_ID=$(curl -s -X GET http://{$CONSUL}:8500/v1/kv/zookeeper?recurse | jq length)
        if [ -z "$ZK_SERVER_ID" ]; then
	        export ZK_SERVER_ID=1
	    else
	    	ZK_SERVER_ID=$[$ZK_SERVER_ID +1]
	    fi
	   	echo "ZK_SERVER_ID is set to:${ZK_SERVER_ID}"
	   	# save id to myid file
	   	echo "${ZK_SERVER_ID}" >> /opt/zookeeper/myid
    fi
}


serverID