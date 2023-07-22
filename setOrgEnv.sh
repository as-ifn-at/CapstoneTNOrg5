#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0




# default to using Platform
ORG=${1:-platform}

# Exit on first error, print all commands.
set -e
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ORDERER_CA=${DIR}/test-network/organizations/ordererOrganizations/chaincart.com/tlsca/tlsca.chaincart.com-cert.pem
PEER0_PLATFORM_CA=${DIR}/test-network/organizations/peerOrganizations/platform.chaincart.com/tlsca/tlsca.platform.chaincart.com-cert.pem
PEER0_FLIPKART_CA=${DIR}/test-network/organizations/peerOrganizations/flipkart.chaincart.com/tlsca/tlsca.flipkart.chaincart.com-cert.pem
PEER0_AMAZON_CA=${DIR}/test-network/organizations/peerOrganizations/amazon.chaincart.com/tlsca/tlsca.amazon.chaincart.com-cert.pem
PEER0_MYNTRA_CA=${DIR}/test-network/organizations/peerOrganizations/myntra.chaincart.com/tlsca/tlsca.myntra.chaincart.com-cert.pem
PEER0_AMAZON_CA=${DIR}/test-network/organizations/peerOrganizations/tataneu.chaincart.com/tlsca/tlsca.tataneu.chaincart.com-cert.pem


if [[ ${ORG} == "platform" || ${ORG} == "digibank" ]]; then

   CORE_PEER_LOCALMSPID=PlatformMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/platform.chaincart.com/users/Admin@platform.chaincart.com/msp
   CORE_PEER_ADDRESS=localhost:7051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/platform.chaincart.com/tlsca/tlsca.platform.chaincart.com-cert.pem

elif [[ ${ORG} == "flipkart" || ${ORG} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=FlipkartMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/flipkart.chaincart.com/users/Admin@flipkart.chaincart.com/msp
   CORE_PEER_ADDRESS=localhost:9051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/flipkart.chaincart.com/tlsca/tlsca.flipkart.chaincart.com-cert.pem

elif [[ ${ORG} == "amazon" || ${ORG} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=AmazonMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/amazon.chaincart.com/users/Admin@amazon.chaincart.com/msp
   CORE_PEER_ADDRESS=localhost:11051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/amazon.chaincart.com/tlsca/tlsca.amazon.chaincart.com-cert.pem

elif [[ ${ORG} == "myntra" || ${ORG} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=MyntraMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/myntra.chaincart.com/users/Admin@myntra.chaincart.com/msp
   CORE_PEER_ADDRESS=localhost:13051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/myntra.chaincart.com/tlsca/tlsca.myntra.chaincart.com-cert.pem

elif [[ ${ORG} == "tataneu" || ${ORG} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=TataneuMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/tataneu.chaincart.com/users/Admin@tataneu.chaincart.com/msp
   CORE_PEER_ADDRESS=localhost:15051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/tataneu.chaincart.com/tlsca/tlsca.tataneu.chaincart.com-cert.pem

else
   echo "Unknown \"$ORG\", please choose Platform/Digibank or Flipkart/Magnetocorp"
   echo "For chaincart to get the environment variables to set upa Flipkart shell environment run:  ./setOrgEnv.sh Flipkart"
   echo
   echo "This can be automated to set them as well with:"
   echo
   echo 'export $(./setOrgEnv.sh Flipkart | xargs)'
   exit 1
fi

# output the variables that need to be set
echo "CORE_PEER_TLS_ENABLED=true"
echo "ORDERER_CA=${ORDERER_CA}"
echo "PEER0_PLATFORM_CA=${PEER0_PLATFORM_CA}"
echo "PEER0_FLIPKART_CA=${PEER0_FLIPKART_CA}"
echo "PEER0_AMAZON_CA=${PEER0_AMAZON_CA}"
echo "PEER0_MYNTRA_CA=${PEER0_MYNTRA_CA}"
echo "PEER0_TATANEU_CA=${PEER0_TATANEU_CA}"

echo "CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH}"
echo "CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS}"
echo "CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE}"

echo "CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID}"
