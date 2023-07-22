#!/bin/bash
packagename="basic"
channelname="mychannel"

echo "------------Package Chaincode-----------"
cd chaincode-go && GO111MODULE=on go mod vendor
sleep 3
cd ..
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
peer version
sleep 2
peer lifecycle chaincode package ${packagename}.tar.gz --path ./chaincode-go/ --lang golang --label ${packagename}_1.0
echo "------------package successfull-----------------"
sleep 2

echo "------------Installing to Org1-----------"
export CORE_PEER_TLS_ENABLED=true
export $(./setOrgEnv.sh org1 | xargs)
peer lifecycle chaincode install ${packagename}.tar.gz
echo "------------Success-----------"

echo "------------Installing to Org2-----------"
export $(./setOrgEnv.sh org2 | xargs)
peer lifecycle chaincode install ${packagename}.tar.gz
echo "------------Success-----------"

echo "------------Installing to Org3-----------"
export $(./setOrgEnv.sh org3 | xargs)
peer lifecycle chaincode install ${packagename}.tar.gz
echo "------------Success-----------"

echo "------------Installing to Org4-----------"
export $(./setOrgEnv.sh org4 | xargs)
peer lifecycle chaincode install ${packagename}.tar.gz
echo "------------Success-----------"

echo "------------Installing to Org5-----------"
export $(./setOrgEnv.sh org5 | xargs)
peer lifecycle chaincode install ${packagename}.tar.gz
echo "------------Success-----------"

peer lifecycle chaincode queryinstalled

b=$(peer lifecycle chaincode queryinstalled)
c=$(echo ${b} | grep -aob ',' | grep -oE '[0-9]+')
pid=$(echo $b| cut -c 43-${c})

export CC_PACKAGE_ID=${pid}

echo ${pid}

echo "=======Approve chaincode by all 3 orgs======="

echo "------------Approving chaincode by Org1-----------"
export CORE_PEER_TLS_ENABLED=true
export $(./setOrgEnv.sh org1 | xargs)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem"
echo "------------Success-----------"

echo "------------Approving chaincode by Org2-----------"
export $(./setOrgEnv.sh org2 | xargs)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem"
echo "------------Success-----------"

echo "------------Approving chaincode by Org3-----------"
export $(./setOrgEnv.sh org3 | xargs)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem"
echo "------------Success-----------"

echo "------------Approving chaincode by Org4-----------"
export $(./setOrgEnv.sh org4 | xargs)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem"
echo "------------Success-----------"

echo "------------Approving chaincode by Org5-----------"
export $(./setOrgEnv.sh org5 | xargs)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem"
echo "------------Success-----------"

peer lifecycle chaincode checkcommitreadiness --channelID ${channelname} --name ${packagename} --version 1.0 --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem" --output json
sleep 3

echo "--------Commit chaincode-------------"
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem" --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.chaincart.com/peers/peer0.org1.chaincart.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.chaincart.com/peers/peer0.org2.chaincart.com/tls/ca.crt" --peerAddresses localhost:11051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org3.chaincart.com/peers/peer0.org3.chaincart.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org4.chaincart.com/peers/peer0.org4.chaincart.com/tls/ca.crt" --peerAddresses localhost:15051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org5.chaincart.com/peers/peer0.org5.chaincart.com/tls/ca.crt"
echo "------------Success-----------"

peer lifecycle chaincode querycommitted --channelID ${channelname} --name ${packagename}

# cd api

# rm -rf wallet
# node enrollBank.js
# node enrollCim.js
# node enrollPlatform.js

# node registerBank.js
# # node registerCim.js
# node registerPlatform.js

# cd ..