// allow lambda service to assume (use) the role with such policy
data "aws_iam_policy_document" "assume_lambda_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

// create lambda role, that lambda function can assume (use)
resource "aws_iam_role" "lambda" {
  name               = "AssumeLambdaRole"
  description        = "Role for lambda to assume lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}

// policy document that allows actions for dynamodb table
data "aws_iam_policy_document" "allow_dynamodb" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:UpdateItem"
    ]

    resources = [
      var.dynamo_table_arn
    ]
  }
}

// create a policy to allow access to dynamodb
resource "aws_iam_policy" "function_dynamodb_policy" {
  name        = "AllowDynamodbPolicy"
  description = "Policy for lambda dynamodb access"
  policy      = data.aws_iam_policy_document.allow_dynamodb.json
}

// attach policy to our created lambda role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy_attachment" {
  role       = aws_iam_role.lambda.id
  policy_arn = aws_iam_policy.function_dynamodb_policy.arn
}

// build the go program on change
resource "null_resource" "go_lambda_build" {
  triggers = {
    source_code = filemd5("${path.module}/hit-counter/main.go")
  }

  provisioner "local-exec" {
    command = <<EOT
      cd ${path.module}/hit-counter
      if [ ! -f go.mod ]; then
        go mod init hit-counter
      fi
      export GOPROXY=direct
      go mod tidy
      GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${local.binary_name} main.go
    EOT
  }
}

// zip the binary, as we can use only zip files to AWS lambda
data "archive_file" "function_archive" {
  depends_on = [null_resource.go_lambda_build]

  type        = "zip"
  source_file = "${path.module}/hit-counter/${local.binary_name}"
  output_path = "${path.module}/hit-counter/${local.binary_name}.zip"
}

// create the lambda function from zip file
resource "aws_lambda_function" "function" {
  function_name = "hit-counter"
  description   = "updates the hit counter in dynamodb and returns the new value"
  role          = aws_iam_role.lambda.arn // assumes the role defined above
  handler       = local.binary_name
  memory_size   = 128

  filename         = "${path.module}/hit-counter/${local.binary_name}.zip"
  source_code_hash = data.archive_file.function_archive.output_base64sha256

  runtime = "provided.al2023"
}

// allows lambda function to be invoked by API Gateway
resource "aws_lambda_permission" "lambda_permission" {
  depends_on = [aws_lambda_function.function]
  statement_id = "AllowHitCounterAPIInvoke"
  action = "lambda:InvokeFunction"
  function_name = "hit-counter"
  principal = "apigateway.amazonaws.com"

  source_arn = "${var.lambda_api_execution_arn}/*"
}