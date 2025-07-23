variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "domain_name" {
  type        = string
  description = "Domain name for the website"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for all resources"
}

variable "use_local_credentials" {
  type = bool
  description = "Allow using local credentials on local machine, github secrets otherwise"
}