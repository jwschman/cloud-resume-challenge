# Create the actual api resource
resource "aws_api_gateway_rest_api" "lambda_api" {
    name        = "lambda-api"
    description = "API for cloud resume challenge lambda function"
}

# make the hit-counter resource
resource "aws_api_gateway_resource" "hit_counter" {
    rest_api_id = aws_api_gateway_rest_api.lambda_api.id
    parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
    path_part   = "hit-counter"
}

# Define api gateway POST method for hit-counter resource
resource "aws_api_gateway_method" "post" {
    rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
    resource_id   = aws_api_gateway_resource.hit_counter.id
    http_method   = "POST"
    authorization = "NONE"
}

# API Gateway Integration with the lambda function for post method
resource "aws_api_gateway_integration" "post" {
    rest_api_id             = aws_api_gateway_rest_api.lambda_api.id
    resource_id             = aws_api_gateway_resource.hit_counter.id
    http_method             = aws_api_gateway_method.post.http_method
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.lambda_invoke_arn
}



# Define OPTIONS method for hit-counter
resource "aws_api_gateway_method" "options" {
    rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
    resource_id   = aws_api_gateway_resource.hit_counter.id
    http_method   = "OPTIONS"
    authorization = "NONE"
}

# Integration for options method for CORS
resource "aws_api_gateway_integration" "options" {
    rest_api_id = aws_api_gateway_rest_api.lambda_api.id
    resource_id = aws_api_gateway_resource.hit_counter.id
    http_method = aws_api_gateway_method.options.http_method
    type        = "MOCK"

    request_templates = {
        "application/json" = "{\"statusCode\": 200}"
    }
}

# Set response for options method
resource "aws_api_gateway_method_response" "options" {
    rest_api_id = aws_api_gateway_rest_api.lambda_api.id
    resource_id = aws_api_gateway_resource.hit_counter.id
    http_method = aws_api_gateway_method.options.http_method
    status_code = "200"

    response_parameters = {
        "method.response.header.Access-Control-Allow-Origin"  = true
        "method.response.header.Access-Control-Allow-Methods" = true
        "method.response.header.Access-Control-Allow-Headers" = true
        "method.response.header.Access-Control-Max-Age"       = true
    }
    response_models = {
        "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "options" {
    depends_on  = [aws_api_gateway_integration.options]
    rest_api_id = aws_api_gateway_rest_api.lambda_api.id
    resource_id = aws_api_gateway_resource.hit_counter.id
    http_method = aws_api_gateway_method.options.http_method
    status_code = aws_api_gateway_method_response.options.status_code

    response_parameters = {
        "method.response.header.Access-Control-Allow-Origin"  = "'*'"
        "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
        "method.response.header.Access-Control-Max-Age"       = "'3600'" // unnecessary?
    }
}

# Deployment (it seems like you used to be able to define stage here, but not anymore)
resource "aws_api_gateway_deployment" "deployment" {
    rest_api_id = aws_api_gateway_rest_api.lambda_api.id

    depends_on = [
        aws_api_gateway_integration.post,
        aws_api_gateway_integration.options,
        aws_api_gateway_integration_response.options,
    ]

    lifecycle {
        create_before_destroy = true
    }
}

# Define Stage for resource
resource "aws_api_gateway_stage" "stage" { 
    deployment_id = aws_api_gateway_deployment.deployment.id 
    rest_api_id = aws_api_gateway_rest_api.lambda_api.id 
    stage_name = "stage" 
}