provider "aws" {
  region = "ap-northeast-1"

  shared_credentials_files = (
    var.use_local_credentials ? ["/home/john/.aws/credentials"] : null
  )
  profile = (
    var.use_local_credentials ? "terraform" : null
  )
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"

  shared_credentials_files = (
    var.use_local_credentials ? ["/home/john/.aws/credentials"] : null
  )
  profile = (
    var.use_local_credentials ? "terraform" : null
  )
}
