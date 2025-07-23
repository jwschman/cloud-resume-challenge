# should contain everything related to cloudfront

resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name = var.website_bucket.bucket_regional_domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
        origin_id   = "${var.bucket_name}-origin"
    }

    enabled         = true
    is_ipv6_enabled = true
    http_version    = "http2and3"
    comment         = "${var.domain_name} distribution"
    default_root_object = "index.html"

    aliases = ["${var.domain_name}", "www.${var.domain_name}"]

    default_cache_behavior {
        cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Caching Disabled
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods         = ["GET", "HEAD"]
        target_origin_id       = "${var.bucket_name}-origin"

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        # default_ttl            = 3600
        # max_ttl                = 86400
        compress               = true

        # Redirect www
        function_association {
            event_type   = "viewer-request"
            function_arn = aws_cloudfront_function.www_redirect.arn
        }


    }
    
    price_class     = "PriceClass_200" // 200 because of Japan

    restrictions {
        geo_restriction {
        restriction_type = "none"
        locations        = []
        }
    }

    viewer_certificate {
        acm_certificate_arn = var.certificate_arn
        ssl_support_method       = "sni-only"
        minimum_protocol_version = "TLSv1.2_2021"
    }
}

# Function for Redirection referenced in distribution above
resource "aws_cloudfront_function" "www_redirect" {
    name    = "www-redirect"
    comment = "Redirects www to root domain"
    runtime = "cloudfront-js-1.0"
    code    = file("${path.module}/cloudfront_function.js")
    publish = true
}

# set origin access control.  Necessary for serving objects from the bucket through cloudfront
resource "aws_cloudfront_origin_access_control" "oac" {
    name = "OAC ${var.website_bucket.bucket}"
    description = "Origin Access Controls for Static Website Hosting on ${var.bucket_name}"
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
}