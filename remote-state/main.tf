provider "aws" {
    region                   = "ap-northeast-1"
    shared_credentials_files = ["/home/john/.aws/credentials"]
    profile                  = "terraform"
}

resource "aws_s3_bucket" "terraform_state" {

    bucket = "jwschman-cloud-resume-challenge-remote-state"
    
    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id

    versioning_configuration {
        status = "Disabled"
    }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
    name = "app-state"
    read_capacity = 1
    write_capacity = 1
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}