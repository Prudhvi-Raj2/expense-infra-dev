terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }
  backend "s3" {
    bucket         = "project1-expense-dev"
    key            = "expense-dev-sg" # you should have unique key, same cannot use in other repos
    region         = "us-east-1"
    dynamodb_table = "project1-expense-dev"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}