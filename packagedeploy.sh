#!/bin/bash
# import constants
. constants.sh

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

echo "------------Installing to Platform-----------"
export CORE_PEER_TLS_ENABLED=true
export $(./setOrgEnv.sh platform | xargs)
peer lifecycle chaincode install ${packagename}.tar.gz
echo "------------Success-----------"

echo "------------Installing to Flipkart-----------"
export $(./setOrgEnv.sh flipkart | xargs)
peer lifecycle chaincode install ${packagename}.tar.gz
echo "------------Success-----------"

echo "------------Installing to Amazon-----------"
export $(./setOrgEnv.sh amazon | xargs)
peer lifecycle chaincode install ${packagename}.tar.gz
echo "------------Success-----------"

echo "------------Installing to Myntra-----------"
export $(./setOrgEnv.sh myntra | xargs)
peer lifecycle chaincode install ${packagename}.tar.gz
echo "------------Success-----------"

echo "------------Installing to Tataneu-----------"
export $(./setOrgEnv.sh tataneu | xargs)
peer lifecycle chaincode install ${packagename}.tar.gz
echo "------------Success-----------"

peer lifecycle chaincode queryinstalled

b=$(peer lifecycle chaincode queryinstalled)
c=$(echo ${b} | grep -aob ',' | grep -oE '[0-9]+')
pid=$(echo $b| cut -c 43-${c})

export CC_PACKAGE_ID=${pid}

echo ${pid}

echo "=======Approve chaincode by all 5 orgs======="

echo "------------Approving chaincode by Platform-----------"
export CORE_PEER_TLS_ENABLED=true
export $(./setOrgEnv.sh platform | xargs)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem"
echo "------------Success-----------"
sleep 5

echo "------------Approving chaincode by Flipkart-----------"
export $(./setOrgEnv.sh flipkart | xargs)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem"
echo "------------Success-----------"
sleep 5

echo "------------Approving chaincode by Amazon-----------"
export $(./setOrgEnv.sh amazon | xargs)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem"
echo "------------Success-----------"
sleep 5

echo "------------Approving chaincode by Myntra-----------"
export $(./setOrgEnv.sh myntra | xargs)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem"
echo "------------Success-----------"
sleep 5

echo "------------Approving chaincode by Tataneu-----------"
export $(./setOrgEnv.sh tataneu | xargs)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem"
echo "------------Success-----------"
sleep 5

peer lifecycle chaincode checkcommitreadiness --channelID ${channelname} --name ${packagename} --version 1.0 --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem" --output json
sleep 3

echo "--------Commit chaincode-------------"
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --channelID ${channelname} --name ${packagename} --version 1.0 --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem" --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/platform.chaincart.com/peers/peer0.platform.chaincart.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/flipkart.chaincart.com/peers/peer0.flipkart.chaincart.com/tls/ca.crt" --peerAddresses localhost:11051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/myntra.chaincart.com/peers/peer0.myntra.chaincart.com/tls/ca.crt" --peerAddresses localhost:15051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/tataneu.chaincart.com/peers/peer0.tataneu.chaincart.com/tls/ca.crt"
echo "------------Success-----------"

peer lifecycle chaincode querycommitted --channelID ${channelname} --name ${packagename}

echo "-----Invoke chaincode----"

peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.chaincart.com --tls --cafile "${PWD}/organizations/ordererOrganizations/chaincart.com/orderers/orderer.chaincart.com/msp/tlscacerts/tlsca.chaincart.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/platform.chaincart.com/peers/peer0.platform.chaincart.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/flipkart.chaincart.com/peers/peer0.flipkart.chaincart.com/tls/ca.crt" --peerAddresses localhost:11051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/amazon.chaincart.com/peers/peer0.amazon.chaincart.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/myntra.chaincart.com/peers/peer0.myntra.chaincart.com/tls/ca.crt" --peerAddresses localhost:15051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/tataneu.chaincart.com/peers/peer0.tataneu.chaincart.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'


sleep 2

peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}' | jq .


# cd api

# rm -rf wallet
# node enrollBank.js
# node enrollCim.js
# node enrollPlatform.js

# node registerBank.js
# # node registerCim.js
# node registerPlatform.js

# cd ..