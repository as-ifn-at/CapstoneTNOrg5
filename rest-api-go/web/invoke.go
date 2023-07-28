package web

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"

	"github.com/hyperledger/fabric-gateway/pkg/client"
)

type TransientData struct {
	Name     string `json:"name"`
	Username string `json:"username"`
	Balance  string `json:"balance"`
	Password string `json:"password"`
}

var requestData struct {
	Function     string        `json:"function"`
	// TransientMap TransientData `json:"transientMap"`
	Args         []string      `json:"args"`
}

// Invoke handles chaincode invoke requests.
func (setup *OrgSetup) Invoke(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Received Invoke request")

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

	chainCodeName := "basic"
	channelID := "mychannel"
	function := requestData.Function
	args := requestData.Args

	fmt.Printf("channel: %s, chaincode: %s, function: %s, args: %s\n", channelID, chainCodeName, function, args)

	network := setup.Gateway.GetNetwork(channelID)
	contract := network.GetContract(chainCodeName)

	txn_proposal, err := contract.NewProposal(function, client.WithArguments(args...))
	if err != nil {
		fmt.Fprintf(w, "Error creating txn proposal: %s", err)
		return
	}
	txn_endorsed, err := txn_proposal.Endorse()
	if err != nil {
		fmt.Fprintf(w, "Error endorsing txn: %s", err)
		return
	}
	txn_committed, err := txn_endorsed.Submit()
	if err != nil {
		fmt.Fprintf(w, "Error submitting transaction: %s", err)
		return
	}
	fmt.Fprintf(w, "Transaction ID : %s Response: %s", txn_committed.TransactionID(), txn_endorsed.Result())
}

// func (setup *OrgSetup) Invoke(w http.ResponseWriter, r *http.Request) {
// 	fmt.Println("Received Invoke request")

// 	// Parse the incoming JSON data

// 	body, err := ioutil.ReadAll(r.Body)
// 	if err != nil {
// 		http.Error(w, "Failed to read the request body", http.StatusInternalServerError)
// 		return
// 	}
// 	defer r.Body.Close()

// 	err = json.Unmarshal(body, &requestData)
// 	if err != nil {
// 		http.Error(w, "Failed to parse JSON data", http.StatusBadRequest)
// 		return
// 	}

// 	// Now you can access the function and transient data from the requestData struct.
// 	function := requestData.Function
// 	transientData := requestData.TransientMap

// 	args := requestData.Args
// 	// Access the transient data fields
// 	name := transientData.Name
// 	username := transientData.Username
// 	balance := transientData.Balance

// 	trandata := make(map[string][]byte)

// 	trandata["name"] = []byte(name)
// 	trandata["username"] = []byte(username)
// 	trandata["balance"] = []byte(balance)
// 	trandata["password"] = []byte(transientData.Password)

// 	fmt.Printf("Function: %s\n", function)
// 	fmt.Printf("Name: %s, Username: %s, Balance: %s\n", name, username, balance)

// 	// Rest of your code for invoking the chaincode goes here...

// 	// Example response for testing
// 	fmt.Fprintf(w, "Function: %s\nName: %s\nUsername: %s\nBalance: %s\n \nPassword: %s\n", function, name, username, balance, transientData.Password)

// 	network := setup.Gateway.GetNetwork("mychannel")
// 	contract := network.GetContract("basic")
// 	txn_proposal, err := contract.NewProposal(function, client.WithArguments(args...), client.WithTransient(trandata))
// 	if err != nil {
// 		fmt.Fprintf(w, "Error creating txn proposal: %s", err)
// 		return
// 	}
// 	txn_endorsed, err := txn_proposal.Endorse()
// 	if err != nil {
// 		fmt.Fprintf(w, "Error endorsing txn: %s", err)
// 		return
// 	}
// 	txn_committed, err := txn_endorsed.Submit()
// 	if err != nil {
// 		fmt.Fprintf(w, "Error submitting transaction: %s", err)
// 		return
// 	}
// 	fmt.Fprintf(w, "Transaction ID : %s Response: %s", txn_committed.TransactionID(), txn_endorsed.Result())

// }
