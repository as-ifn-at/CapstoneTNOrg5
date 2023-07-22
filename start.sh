#!/bin/bash
# start test-network with couchdb as database

channelname="mychannel"

./network.sh down && ./network.sh up createChannel -c ${channelname} -ca -s couchdb

sleep 2

./packagedeploy.sh