terraform {
    backend "s3" {
        bucket = "jwschman-cloud-resume-challenge-remote-state"
        key    = "terraform.tfstate"
        region = "ap-northeast-1"
    } 

    required_providers {
        aws = {
            source               = "hashicorp/aws"
            version = "~> 5.0"
            configuration_aliases = [aws.acm]
        }
    }
}
