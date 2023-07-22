#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0




# default to using Org1
ORG=${1:-Org1}

# Exit on first error, print all commands.
set -e
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ORDERER_CA=${DIR}/test-network/organizations/ordererOrganizations/chaincart.com/tlsca/tlsca.chaincart.com-cert.pem
PEER0_ORG1_CA=${DIR}/test-network/organizations/peerOrganizations/org1.chaincart.com/tlsca/tlsca.org1.chaincart.com-cert.pem
PEER0_ORG2_CA=${DIR}/test-network/organizations/peerOrganizations/org2.chaincart.com/tlsca/tlsca.org2.chaincart.com-cert.pem
PEER0_ORG3_CA=${DIR}/test-network/organizations/peerOrganizations/org3.chaincart.com/tlsca/tlsca.org3.chaincart.com-cert.pem
PEER0_ORG4_CA=${DIR}/test-network/organizations/peerOrganizations/org4.chaincart.com/tlsca/tlsca.org4.chaincart.com-cert.pem
PEER0_ORG3_CA=${DIR}/test-network/organizations/peerOrganizations/org5.chaincart.com/tlsca/tlsca.org5.chaincart.com-cert.pem


if [[ ${ORG} == "org1" || ${ORG} == "digibank" ]]; then

   CORE_PEER_LOCALMSPID=Org1MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/org1.chaincart.com/users/Admin@org1.chaincart.com/msp
   CORE_PEER_ADDRESS=localhost:7051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/org1.chaincart.com/tlsca/tlsca.org1.chaincart.com-cert.pem

elif [[ ${ORG} == "org2" || ${ORG} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=Org2MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/org2.chaincart.com/users/Admin@org2.chaincart.com/msp
   CORE_PEER_ADDRESS=localhost:9051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/org2.chaincart.com/tlsca/tlsca.org2.chaincart.com-cert.pem

elif [[ ${ORG} == "org3" || ${ORG} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=Org3MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/org3.chaincart.com/users/Admin@org3.chaincart.com/msp
   CORE_PEER_ADDRESS=localhost:11051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/org3.chaincart.com/tlsca/tlsca.org3.chaincart.com-cert.pem

elif [[ ${ORG} == "org4" || ${ORG} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=Org4MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/org4.chaincart.com/users/Admin@org4.chaincart.com/msp
   CORE_PEER_ADDRESS=localhost:13051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/org4.chaincart.com/tlsca/tlsca.org4.chaincart.com-cert.pem

elif [[ ${ORG} == "org5" || ${ORG} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=Org5MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/org5.chaincart.com/users/Admin@org5.chaincart.com/msp
   CORE_PEER_ADDRESS=localhost:15051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/org5.chaincart.com/tlsca/tlsca.org5.chaincart.com-cert.pem

else
   echo "Unknown \"$ORG\", please choose Org1/Digibank or Org2/Magnetocorp"
   echo "For chaincart to get the environment variables to set upa Org2 shell environment run:  ./setOrgEnv.sh Org2"
   echo
   echo "This can be automated to set them as well with:"
   echo
   echo 'export $(./setOrgEnv.sh Org2 | xargs)'
   exit 1
fi

# output the variables that need to be set
echo "CORE_PEER_TLS_ENABLED=true"
echo "ORDERER_CA=${ORDERER_CA}"
echo "PEER0_ORG1_CA=${PEER0_ORG1_CA}"
echo "PEER0_ORG2_CA=${PEER0_ORG2_CA}"
echo "PEER0_ORG3_CA=${PEER0_ORG3_CA}"
echo "PEER0_ORG4_CA=${PEER0_ORG4_CA}"
echo "PEER0_ORG5_CA=${PEER0_ORG5_CA}"

echo "CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH}"
echo "CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS}"
echo "CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE}"

echo "CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID}"
