
terraform {
  backend "s3" {
    bucket = "myTerraformBucket"
    key    = "mh/aws-quickstart-module/terraform.state"
    region = "eu-west-1"

    dynamodb_table = "myTerraformLockTable"
    encrypt        = true
  }
}
provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      Project     = var.project
      Owner       = var.owner
      Contact     = var.contact
      Environment = var.environment
    }
  }
}

module "test-kitchen" {
  source       = "../../modules/test-kitchen"
  vpc_cidr     = "10.0.0.0/16"
  trusted_cidr = ["1.2.3.4/32", "4.3.2.1/32"]
}
