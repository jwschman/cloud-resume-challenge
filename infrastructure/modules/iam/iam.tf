# Bucket policy for cloudfront
# will use the cloudfront document defined next
resource "aws_s3_bucket_policy" "allow_cloudfront" {
    bucket = var.website_bucket.bucket
    policy = data.aws_iam_policy_document.cloudfront.json
}

# iam policy used above
data "aws_iam_policy_document" "cloudfront" {
    statement {
        effect = "Allow"
        actions = ["s3:GetObject"]
        resources = ["${var.website_bucket.arn}/*"]

        principals {
            type        = "Service"
            identifiers = ["cloudfront.amazonaws.com"]
        }

        condition {
            test     = "StringEquals"
            variable = "aws:SourceArn" # NOT PrincipalArn
            values   = [var.s3_distribution_arn]
        }
    }
}