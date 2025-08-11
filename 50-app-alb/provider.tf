terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }
  backend "s3" {
    bucket         = "expense-dev-vpc-aug2025"
    key            = "expense-dev-alb-05aug25-1" # you should have unique key, same cannot use in other repos
    region         = "us-east-1"
    dynamodb_table = "expense-dev-vpc-aug2025"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}