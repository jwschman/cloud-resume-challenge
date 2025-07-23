# Should contain everything related to the bucket for the static site

# S3 bucket to store the static site
resource "aws_s3_bucket" "website" {
    bucket = "jwschman-cloud-resume-challenge-bucket"

    tags = {
        Name = "Cloud Resume Challenge Bucket"
        Environment = "Development"
    }
}

# Set the bucket acl to private and block access
resource "aws_s3_bucket_acl" "website" {
    depends_on = [
        aws_s3_bucket_ownership_controls.website_bucket,
        aws_s3_bucket_public_access_block.website_bucket
    ]

    bucket = local.website-bucket
    acl    = "private"
}

# This might be unnecessary with the ACL from up there, but it was in a guide so I'm leaving it in
resource "aws_s3_bucket_public_access_block" "website_bucket" {
    bucket                  = local.website-bucket
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

# ownership and access controls
# sets all uploaded objects to be owned by the bucket owner (i think)
resource "aws_s3_bucket_ownership_controls" "website_bucket" {
    bucket = local.website-bucket
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

# add all objects in frontend
resource "aws_s3_object" "static_files" {
    for_each     = fileset(var.website_dir, "**")
    bucket       = local.website-bucket
    key          = each.key
    source       = "${var.website_dir}/${each.key}"
    content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
    etag         = filemd5("${var.website_dir}/${each.value}")
}