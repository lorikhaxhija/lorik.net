terraform {
  backend "s3" {
    bucket       = "lorik-tofu-state-eu-west-2-4tjz5"
    key          = "bootstrap/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

//resource "aws_s3_bucket" "weather-snapshots" {
//  bucket_prefix = "lorik-weather-"
//}
