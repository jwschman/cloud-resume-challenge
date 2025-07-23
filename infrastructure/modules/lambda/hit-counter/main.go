package main

import (
	"encoding/json"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
)

func handler(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	// Create Session
	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	// Create DynamoDB Client
	svc := dynamodb.New(sess)

	// create the UpdateItemInput so we can actually update the item
	// this is just how it's done.  Make the thing to be updated, and then update it
	input := &dynamodb.UpdateItemInput{
		TableName: aws.String("hit-counter"), // name of the table we're using
		Key: map[string]*dynamodb.AttributeValue{
			"hit-counter": {
				S: aws.String("counter"), // we are looking for the key in the table called "counter"  of type "S"
			},
		},
		ExpressionAttributeNames: map[string]*string{
			"#val": aws.String("value"), // alias value (the key of what we want to update) to #val, since 'value' is a reserved keyword
		},
		ExpressionAttributeValues: map[string]*dynamodb.AttributeValue{
			":toadd": {
				N: aws.String("1"), // we are going to add this (1) to the value since it updates on every page view
			},
		},
		UpdateExpression: aws.String("SET #val = #val + :toadd"), // we are going to set #val to the initial value plus toadd (1)
		ReturnValues:     aws.String("UPDATED_NEW"),              // return only the updated values when this item is actually updated
	}

	// actually update the item here, and get the output of new value
	output, err := svc.UpdateItem(input)
	if err != nil {
		log.Printf("UpdateItem failed: %v", err)
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Headers: map[string]string{
				"Content-Type": "application/json",
			},
			Body: `{"error": "Internal Server Error"}`,
		}, nil
	}

	// the only thing we really want is the updated value, not the full output
	updatedValue := output.Attributes["value"].N
	responseBody, _ := json.Marshal(map[string]string{
		"hit-count": *updatedValue,
	})

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type":                 "application/json",
			"Access-Control-Allow-Origin":  "*",                          // FOR CORS
			"Access-Control-Allow-Methods": "POST,OPTIONS",               // FOR CORS
			"Access-Control-Allow-Headers": "Content-Type,Authorization", // FOR CORS
		},
		Body: string(responseBody),
	}, nil
}

func main() {
	lambda.Start(handler)
}
