package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
)

type Response struct {
	Balance int `json:"balance"`
}

func getBalanceByID(c *gin.Context) {
	id := c.Param("username")

	requestBody := fmt.Sprintf(`{"function":"GetBalance","args":["%s"]}`, id)

	fmt.Printf("requestBody----: %v\n", requestBody)

	contentType := "application/json"

	response, err := http.Post("http://localhost:3001/query", contentType, bytes.NewBufferString(requestBody))

	if err != nil {
		fmt.Print(err.Error())
		os.Exit(1)
	}

	responseData, err := io.ReadAll(response.Body)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(string(responseData))

	k := string(responseData)
	indexOfOpenBracket := strings.Index(k, "{")
	extractedString := k[indexOfOpenBracket:]
	var resp Response

	err = json.Unmarshal([]byte(extractedString), &resp) 
	if err != nil {
		panic(err)
	}
	c.IndentedJSON(http.StatusOK, resp.Balance)
}

func corsMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "http://localhost:4200")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(200)
			return
		}

		c.Next()
	}
}

func main() {

	router := gin.Default()

	router.Use(corsMiddleware())
	router.GET("/getbalance/:username", getBalanceByID)

	router.Run("localhost:8082")
}
