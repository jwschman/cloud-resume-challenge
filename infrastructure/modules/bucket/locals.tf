locals {
    website-bucket = aws_s3_bucket.website.bucket

    # Aligns file extensions with their appropriate MIME types, guaranteeing accurate content delivery for various assets.
    content_types = {
        ".html" : "text/html",
        ".css" : "text/css",
        ".js" : "application/javascript",
        ".json" : "application/json",
        ".xml" : "application/xml",
        ".jpg" : "image/jpeg",
        ".jpeg" : "image/jpeg",
        ".png" : "image/png",
        ".gif" : "image/gif",
        ".svg" : "image/svg+xml",
        ".webp" : "image/webp",
        ".ico" : "image/x-icon",
        ".woff" : "font/woff",
        ".woff2" : "font/woff2",
        ".ttf" : "font/ttf",
        ".eot" : "application/vnd.ms-fontobject",
        ".otf" : "font/otf"
    }
}