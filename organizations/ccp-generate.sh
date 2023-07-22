#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${ORGM}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${ORGM}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG="platform"
ORGM="Platform"
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/platform.chaincart.com/tlsca/tlsca.platform.chaincart.com-cert.pem
CAPEM=organizations/peerOrganizations/platform.chaincart.com/ca/ca.platform.chaincart.com-cert.pem

echo "$(json_ccp $ORG $ORGM $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/platform.chaincart.com/connection-platform.json
echo "$(yaml_ccp $ORG $ORGM $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/platform.chaincart.com/connection-platform.yaml

ORG="flipkart"
ORGM="Flipkart"
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/flipkart.chaincart.com/tlsca/tlsca.flipkart.chaincart.com-cert.pem
CAPEM=organizations/peerOrganizations/flipkart.chaincart.com/ca/ca.flipkart.chaincart.com-cert.pem

echo "$(json_ccp $ORG $ORGM $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/flipkart.chaincart.com/connection-flipkart.json
echo "$(yaml_ccp $ORG $ORGM $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/flipkart.chaincart.com/connection-flipkart.yaml

ORG="amazon"
ORGM="Amazon"
P0PORT=11051
CAPORT=11154
PEERPEM=organizations/peerOrganizations/amazon.chaincart.com/tlsca/tlsca.amazon.chaincart.com-cert.pem
CAPEM=organizations/peerOrganizations/amazon.chaincart.com/ca/ca.amazon.chaincart.com-cert.pem

echo "$(json_ccp $ORG $ORGM $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/amazon.chaincart.com/connection-amazon.json
echo "$(yaml_ccp $ORG $ORGM $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/amazon.chaincart.com/connection-amazon.yaml

ORG="myntra"
ORGM="Myntra"
P0PORT=13051
CAPORT=10054
PEERPEM=organizations/peerOrganizations/myntra.chaincart.com/tlsca/tlsca.myntra.chaincart.com-cert.pem
CAPEM=organizations/peerOrganizations/myntra.chaincart.com/ca/ca.myntra.chaincart.com-cert.pem

echo "$(json_ccp $ORG $ORGM $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/myntra.chaincart.com/connection-myntra.json
echo "$(yaml_ccp $ORG $ORGM $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/myntra.chaincart.com/connection-myntra.yaml

ORG="tataneu"
ORGM="Tataneu"
P0PORT=15051
CAPORT=11054
PEERPEM=organizations/peerOrganizations/tataneu.chaincart.com/tlsca/tlsca.tataneu.chaincart.com-cert.pem
CAPEM=organizations/peerOrganizations/tataneu.chaincart.com/ca/ca.tataneu.chaincart.com-cert.pem

echo "$(json_ccp $ORG $ORGM $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/tataneu.chaincart.com/connection-tataneu.json
echo "$(yaml_ccp $ORG $ORGM $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/tataneu.chaincart.com/connection-tataneu.yaml