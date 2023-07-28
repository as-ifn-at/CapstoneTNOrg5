package web

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

// Query handles chaincode query requests.
func (setup OrgSetup) Query(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Received Query request")
	chainCodeName := "basic"
	channelID := "mychannel"

	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "Failed to read the request body", http.StatusInternalServerError)
		return
	}
	defer r.Body.Close()

	err = json.Unmarshal(body, &requestData)

	if err != nil {
		panic(err)
	}

	function := requestData.Function
	args := requestData.Args
	fmt.Printf("channel: %s, chaincode: %s, function: %s, args: %s\n", channelID, chainCodeName, function, args)

	network := setup.Gateway.GetNetwork(channelID)
	contract := network.GetContract(chainCodeName)
	evaluateResponse, err := contract.EvaluateTransaction(function, args...)
	if err != nil {
		fmt.Fprintf(w, "Error: %s", err)
		return
	}
	fmt.Fprintf(w, "Response: %s", evaluateResponse)
}
