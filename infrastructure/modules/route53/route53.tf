# Hosted Zone
data "aws_route53_zone" "existing" {
    name = var.domain_name
}

# Actual Records
resource "aws_route53_record" "root_a" {
    zone_id = data.aws_route53_zone.existing.zone_id
    name    = "${var.domain_name}"
    type    = "A"
    alias {
        name = var.s3_distribution.domain_name
        zone_id = var.s3_distribution.hosted_zone_id
        evaluate_target_health = false
    }
}

# for www prefix
resource "aws_route53_record" "www_a" {
    zone_id = data.aws_route53_zone.existing.zone_id
    name    = "www.${var.domain_name}"
    type    = "A"

    alias {
        name = var.s3_distribution.domain_name
        zone_id = var.s3_distribution.hosted_zone_id
        evaluate_target_health = false
    }
}