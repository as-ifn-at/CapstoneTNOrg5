package main

import (
	"fmt"
	"rest-api-go/web"
)

func main() {
	//Initialize setup for Platform
	cryptoPath := "../organizations/peerOrganizations/platform.chaincart.com"
	orgConfig := web.OrgSetup{
		OrgName:      "Platform",
		MSPID:        "PlatformMSP",
		CertPath:     cryptoPath + "/users/User1@platform.chaincart.com/msp/signcerts/cert.pem",
		KeyPath:      cryptoPath + "/users/User1@platform.chaincart.com/msp/keystore/",
		TLSCertPath:  cryptoPath + "/peers/peer0.platform.chaincart.com/tls/ca.crt",
		PeerEndpoint: "localhost:7051",
		GatewayPeer:  "peer0.platform.chaincart.com",
	}

	orgSetup, err := web.Initialize(orgConfig)
	if err != nil {
		fmt.Println("Error initializing setup for Platform: ", err)
	}
	web.Serve(web.OrgSetup(*orgSetup))
}
