output cloudfront_s3_distribution {
    value = aws_cloudfront_distribution.s3_distribution
}

output cloudfront_s3_distribution_arn {
    value = aws_cloudfront_distribution.s3_distribution.arn
}