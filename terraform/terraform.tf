provider "aws" {
  profile = "terraform"
  default_tags {
    tags = {
      name = "refactored-dollop"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "refactored-dollop-tfstate"
    key    = "tfstate"
    region = "ap-northeast-1"
  }
}
