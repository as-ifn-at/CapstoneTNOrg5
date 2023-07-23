package chaincode

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// var currentTotatlSupply int = 0

type SmartContract struct {
	contractapi.Contract
}

type Token struct {
	ObjectType string `json:"docType"`
	ID         string `json:"ID"`
	Owner      string `json:"owner"`
	Name       string `json:"name"`
	Symbol     string `json:"symbol"`
}

type TokenSupply struct {
	TotalSupply  float64 `json:"TotalSupply"`
	BurnAmount   float64 `json:"BurnAmount"`
	ChangeAmount float64 `json:"ChangeAmount"`
}

type TokenTransfer struct {
	ID       string `json:"ID"`
	NewOwner string `json:"newOwner"`
	Amount   int    `json:"amount"`
}

type UserBalance struct {
	User    string `json:"user"`
	Balance int    `json:"balance"`
}

type User struct {
	ObjectType       string   `json:"docType"`
	Name             string   `json:"name"`
	Username         string   `json:"username"`
	Balance          int      `json:"balance"`
	Password         string   `json:"password"`
	ProductsBought   []string `json:"productsBought"`
	ProductsReturned []string `json:"productsReturned"`
	Cashback         int      `json:"cashback"`
}

type UserRegistrationContract struct {
	contractapi.Contract
}

func (c *UserRegistrationContract) RegisterUser(ctx contractapi.TransactionContextInterface) error {
	transientData, err := ctx.GetStub().GetTransient()
	if err != nil {
		return fmt.Errorf("failed to get transient data: %w", err)
	}

	if _, ok := transientData["name"]; !ok {
		return fmt.Errorf("name is required in transient data")
	}
	if _, ok := transientData["username"]; !ok {
		return fmt.Errorf("username is required in transient data")
	}
	if _, ok := transientData["password"]; !ok {
		return fmt.Errorf("password is required in transient data")
	}
	if _, ok := transientData["balance"]; !ok {
		return fmt.Errorf("balance is required in transient data")
	}

	name := string(transientData["name"])
	username := string(transientData["username"])
	password := string(transientData["password"])
	balance := int(transientData["balance"][0])

	existing, err := ctx.GetStub().GetState(username)
	if err != nil {
		return fmt.Errorf("failed to read from world state: %w", err)
	}
	if existing != nil {
		return fmt.Errorf("user with username %s already exists", username)
	}

	user := User{
		ObjectType:       "user",
		Name:             name,
		Username:         username,
		Balance:          balance,
		Password:         password,
		ProductsBought:   []string{},
		ProductsReturned: []string{},
		Cashback:         0,
	}

	userBytes, err := json.Marshal(user)
	if err != nil {
		return fmt.Errorf("failed to marshal user: %w", err)
	}

	err = ctx.GetStub().PutPrivateData("collectionUser", username, userBytes)
	if err != nil {
		return fmt.Errorf("failed to put user on private data: %w", err)
	}

	return nil
}

func (c *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	tokenSup := &TokenSupply{
		TotalSupply:  10000.0,
		BurnAmount:   0,
		ChangeAmount: 0,
	}

	tokenSupBytes, err := json.Marshal(tokenSup)
	if err != nil {
		return err
	}

	err = ctx.GetStub().PutState("TotalSupply", tokenSupBytes)
	if err != nil {
		return fmt.Errorf("failed to put token on world state: %w", err)
	}

	return nil
}

func (c *SmartContract) CreateToken(ctx contractapi.TransactionContextInterface, amount float64) error {
	// Check if the invoker is the platform
	// platformID, err := ctx.GetClientIdentity().GetID()
	// if err != nil {
	// 	return fmt.Errorf("failed to get client identity: %w", err)
	// }
	// if platformID != "BankMSP" { // Replace "<platform ID>" with the actual platform identity
	// 	return fmt.Errorf("only the platform is authorized to create tokens")
	// }

	existing, err := ctx.GetStub().GetState("TotalSupply")
	if err != nil {
		return fmt.Errorf("failed to read from world state: %w", err)
	}
	// if existing != nil {
	// 	return fmt.Errorf("token with ID %s already exists", id)
	// }

	// token := Token{
	// 	ObjectType: "token",
	// 	ID:         id,
	// 	Owner:      "Platform",
	// 	Name:       name,
	// 	Symbol:     symbol,
	// }
	var NewToken TokenSupply

	err = json.Unmarshal(existing, &NewToken)
	if err != nil {
		return err
	}

	NewToken.TotalSupply += amount
	NewToken.ChangeAmount = amount

	tokenBytes, err := json.Marshal(NewToken)
	if err != nil {
		return fmt.Errorf("failed to marshal token: %w", err)
	}

	err = ctx.GetStub().PutState("TotalSupply", tokenBytes)
	if err != nil {
		return fmt.Errorf("failed to put token on world state: %w", err)
	}

	return nil
}

func (c *SmartContract) BurnToken(ctx contractapi.TransactionContextInterface, id string) error {
	// Check if the invoker is the platform
	platformID, err := ctx.GetClientIdentity().GetID()
	if err != nil {
		return fmt.Errorf("failed to get client identity: %w", err)
	}
	if platformID != "<platform ID>" { // Replace "<platform ID>" with the actual platform identity
		return fmt.Errorf("only the platform is authorized to burn tokens")
	}

	existing, err := ctx.GetStub().GetState(id)
	if err != nil {
		return fmt.Errorf("failed to read from world state: %w", err)
	}
	if existing == nil {
		return fmt.Errorf("token with ID %s does not exist", id)
	}

	err = ctx.GetStub().DelState(id)
	if err != nil {
		return fmt.Errorf("failed to delete token from world state: %w", err)
	}

	return nil
}

func (c *SmartContract) TransferTokens(ctx contractapi.TransactionContextInterface, transfers []TokenTransfer) error {
	for _, transfer := range transfers {
		existing, err := ctx.GetStub().GetState(transfer.ID)
		if err != nil {
			return fmt.Errorf("failed to read from world state: %w", err)
		}
		if existing == nil {
			return fmt.Errorf("token with ID %s does not exist", transfer.ID)
		}

		token := &Token{}
		err = json.Unmarshal(existing, token)
		if err != nil {
			return fmt.Errorf("failed to unmarshal token: %w", err)
		}

		// Check if the invoker is the platform or the token owner
		invokerID, err := ctx.GetClientIdentity().GetID()
		if err != nil {
			return fmt.Errorf("failed to get client identity: %w", err)
		}
		if invokerID != token.Owner && invokerID != "<platform ID>" { // Replace "<platform ID>" with the actual platform identity
			return fmt.Errorf("only the platform or token owner can transfer tokens")
		}

		// Check the token balance of the owner
		ownerBalance, err := c.GetBalance(ctx, token.Owner)
		if err != nil {
			return fmt.Errorf("failed to get token balance: %w", err)
		}
		if ownerBalance.Balance < transfer.Amount {
			return fmt.Errorf("insufficient token balance for transfer")
		}

		// Update the owner of the token
		token.Owner = transfer.NewOwner

		tokenBytes, err := json.Marshal(token)
		if err != nil {
			return fmt.Errorf("failed to marshal token: %w", err)
		}

		err = ctx.GetStub().PutState(transfer.ID, tokenBytes)
		if err != nil {
			return fmt.Errorf("failed to update token on world state: %w", err)
		}
	}

	return nil
}

func (c *SmartContract) GetBalance(ctx contractapi.TransactionContextInterface, user string) (*UserBalance, error) {
	balance := 0

	queryString := fmt.Sprintf(`{
		"selector": {
			"docType": "token",
			"owner": "%s"
			}
		}`, user)

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, fmt.Errorf("failed to get query result: %w", err)
	}
	defer resultsIterator.Close()

	for resultsIterator.HasNext() {
		result, err := resultsIterator.Next()
		if err != nil {
			return nil, fmt.Errorf("failed to iterate query result: %w", err)
		}

		token := &Token{}
		err = json.Unmarshal(result.Value, token)
		if err != nil {
			return nil, fmt.Errorf("failed to unmarshal token: %w", err)
		}

		balance++
	}

	userBalance := &UserBalance{
		User:    user,
		Balance: balance,
	}

	return userBalance, nil
}

// func main() {
// 	chaincode, err := contractapi.NewChaincode(new(SmartContract))
// 	if err != nil {
// 		fmt.Printf("Error creating SmartContract chaincode: %s", err.Error())
// 		return
// 	}

// 	if err := chaincode.Start(); err != nil {
// 		fmt.Printf("Error starting SmartContract chaincode: %s", err.Error())
// 	}
// }
