#!/bin/bash
# start test-network with couchdb as database

# import constants
. constants.sh

# ./network.sh down && ./network.sh up createChannel -c ${channelname} -ca -s ${database}
./network.sh down && ./network.sh up createChannel -c ${channelname} -ca

sleep 2

./packagedeploy.sh