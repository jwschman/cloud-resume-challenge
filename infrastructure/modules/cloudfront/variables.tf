variable bucket_name {
    description = "name of the website frontend bucket"
    type = string
}

variable website_bucket {
    description = "frontend bucket object"
}

variable domain_name {
    description = "the domain used for cloudfront"
    type = string
}

variable "certificate_arn" {
    description = "ARN of the SSL certificate to associate with CloudFront"
    type        = string
}