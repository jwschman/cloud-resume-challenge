module "api-gateway" {
    source = "../../modules/api-gateway"

    lambda_invoke_arn = module.lambda.lambda_invoke_arn
}

module "bucket" {
    source = "../../modules/bucket"
    website_dir = "../../../website"
}

module "cloudfront" {
    source = "../../modules/cloudfront"

    bucket_name = var.bucket_name
    domain_name = var.domain_name
    website_bucket = module.bucket.website_bucket
    certificate_arn = module.acm.acm_certificate_arn

}

module "database" {
    source = "../../modules/database"
}

module "iam" {
    source = "../../modules/iam"

    website_bucket = module.bucket.website_bucket
    s3_distribution_arn = module.cloudfront.cloudfront_s3_distribution_arn
}

module "lambda" { 
    source = "../../modules/lambda"

    dynamo_table_arn = module.database.dynamo_table_arn
    lambda_api_execution_arn = module.api-gateway.lambda_api_execution_arn
}

module "route53" {
    source = "../../modules/route53"
    domain_name = var.domain_name
    s3_distribution = module.cloudfront.cloudfront_s3_distribution
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.0"

  providers = {
    aws = aws.acm
  }

  domain_name = "${var.domain_name}"
  subject_alternative_names = [
    "www.${var.domain_name}"
  ]

  zone_id             = module.route53.existing.zone_id
  validation_method   = "DNS"
  wait_for_validation = true

  tags = {
    Name = "jwschman.click"
  }
}
