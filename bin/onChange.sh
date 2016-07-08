#!/bin/bash

echo "onChange event triggered"
/opt/zookeeper/initZK.sh
/opt/zookeeper/bin/zkServer.sh restart