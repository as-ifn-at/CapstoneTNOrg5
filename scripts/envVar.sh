#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/chaincart.com/tlsca/tlsca.chaincart.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.chaincart.com/tlsca/tlsca.org1.chaincart.com-cert.pem
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.chaincart.com/tlsca/tlsca.org2.chaincart.com-cert.pem
export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.chaincart.com/tlsca/tlsca.org3.chaincart.com-cert.pem
export PEER0_ORG4_CA=${PWD}/organizations/peerOrganizations/org4.chaincart.com/tlsca/tlsca.org4.chaincart.com-cert.pem
export PEER0_ORG5_CA=${PWD}/organizations/peerOrganizations/org5.chaincart.com/tlsca/tlsca.org5.chaincart.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.chaincart.com/users/Admin@org1.chaincart.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.chaincart.com/users/Admin@org2.chaincart.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.chaincart.com/users/Admin@org3.chaincart.com/msp
    export CORE_PEER_ADDRESS=localhost:11051

  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="Org4MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG4_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org4.chaincart.com/users/Admin@org4.chaincart.com/msp
    export CORE_PEER_ADDRESS=localhost:13051

  elif [ $USING_ORG -eq 5 ]; then
    export CORE_PEER_LOCALMSPID="Org5MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG5_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org5.chaincart.com/users/Admin@org5.chaincart.com/msp
    export CORE_PEER_ADDRESS=localhost:15051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.org1.chaincart.com:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.org2.chaincart.com:9051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.org3.chaincart.com:11051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_ADDRESS=peer0.org4.chaincart.com:13051
  elif [ $USING_ORG -eq 5 ]; then
    export CORE_PEER_ADDRESS=peer0.org5.chaincart.com:15051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	PEERS="$PEER"
    else
	PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    CA=PEER0_ORG$1_CA
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
