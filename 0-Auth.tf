provider "aws" {
  region = var.aws_region
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# git commit -m "Updated Variables"

# curl -I http://ec2-16-147-224-181.us-west-2.compute.amazonaws.com