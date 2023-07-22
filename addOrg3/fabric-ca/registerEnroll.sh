#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function createAmazon {
	infoln "Enrolling the CA admin"
	mkdir -p ../organizations/peerOrganizations/amazon.chaincart.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-amazon --tls.certfiles "${PWD}/fabric-ca/amazon/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-amazon.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-amazon.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-amazon.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-amazon.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/msp/config.yaml"

	infoln "Registering peer0"
  set -x
	fabric-ca-client register --caname ca-amazon --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/fabric-ca/amazon/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-amazon --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/fabric-ca/amazon/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-amazon --id.name amazonadmin --id.secret amazonadminpw --id.type admin --tls.certfiles "${PWD}/fabric-ca/amazon/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-amazon -M "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/msp" --tls.certfiles "${PWD}/fabric-ca/amazon/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/msp/config.yaml" "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-amazon -M "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/tls" --enrollment.profile tls --csr.hosts peer0.amazon.chaincart.com --csr.hosts localhost --tls.certfiles "${PWD}/fabric-ca/amazon/tls-cert.pem"
  { set +x; } 2>/dev/null


  cp "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/tls/tlscacerts/"* "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/tls/ca.crt"
  cp "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/tls/signcerts/"* "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/tls/server.crt"
  cp "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/tls/keystore/"* "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/tls/server.key"

  mkdir "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/msp/tlscacerts"
  cp "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/tls/tlscacerts/"* "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/msp/tlscacerts/ca.crt"

  mkdir "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/tlsca"
  cp "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/tls/tlscacerts/"* "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/tlsca/tlsca.amazon.chaincart.com-cert.pem"

  mkdir "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/ca"
  cp "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/msp/cacerts/"* "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/ca/ca.amazon.chaincart.com-cert.pem"

  infoln "Generating the user msp"
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-amazon -M "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/users/User1@amazon.chaincart.com/msp" --tls.certfiles "${PWD}/fabric-ca/amazon/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/msp/config.yaml" "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/users/User1@amazon.chaincart.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
	fabric-ca-client enroll -u https://amazonadmin:amazonadminpw@localhost:11054 --caname ca-amazon -M "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/users/Admin@amazon.chaincart.com/msp" --tls.certfiles "${PWD}/fabric-ca/amazon/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/msp/config.yaml" "${PWD}/../organizations/peerOrganizations/amazon.chaincart.com/users/Admin@amazon.chaincart.com/msp/config.yaml"
}
