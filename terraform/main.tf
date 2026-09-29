terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket  = "duple-tf-state-998877" # (Or whatever unique name you used)
    key     = "prod/terraform.tfstate"
    region  = "us-east-1"
    profile = "duple-dev" # <-- Add this line right here
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "duple-dev"
}