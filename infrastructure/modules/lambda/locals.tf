// for golang lambda
locals {
  function_name = "hello-world"
  src_path      = "/home/john/git/jwschman/cloud-resume-challenge/terraform/cloud-challenge/lambda/${local.function_name}"

  binary_name  = "bootstrap"
  binary_path  = "/home/john/git/jwschman/cloud-resume-challenge/terraform/cloud-challenge/lambda/tf_generated/${local.binary_name}"
  archive_path = "/home/john/git/jwschman/cloud-resume-challenge/terraform/cloud-challenge/lambda/tf_generated/${local.function_name}.zip"
}

output "binary_path" {
  value = local.binary_path
}