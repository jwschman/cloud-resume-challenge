# Define the table
resource "aws_dynamodb_table" "hit-counter" {
    name           = "hit-counter"
    billing_mode   = "PAY_PER_REQUEST"
    hash_key       = "hit-counter"

    attribute {
        name = "hit-counter"
        type = "S"
    }

    tags = {
        Name        = "hit-counter"
        Environment = "test"
    }
}

# Initial value
resource "aws_dynamodb_table_item" "initial_value" {
    depends_on = [ aws_dynamodb_table.hit-counter ]
    table_name = aws_dynamodb_table.hit-counter.name
    hash_key = aws_dynamodb_table.hit-counter.hash_key
    item = <<EOF
    {
        "hit-counter":{"S": "counter"},
        "value":{"N": "0"}
    }
    EOF
}