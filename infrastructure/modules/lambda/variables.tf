variable "dynamo_table_arn" {
    description = "the arn of the dynamobd table to use for the hit counter"
}

variable "lambda_api_execution_arn" {
    description = "the arn of the lambda api gateway... I hope this doesn't give me a circular dependency"
}