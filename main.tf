terraform {
  required_providers {
    conjur = {
        source  = "cyberark/conjur"
        version = "0.6.9"
    }
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "conjur" {
  appliance_url = "https://<your_instance>.secretsmgr.cyberark.cloud" # Update to match your pcloud instance
  account       = "conjur" 
  login         = "host/data/tf-setup" # Update with the host id
  api_key       = "API_TOKEN" # Update API token
}

data "conjur_secret" "aws_creds" {
    name = "data/dynamic/AWS-S3-Bucket-Creation" # Update your variable path
}

# We're recieving a json response and just store it as a string, so we need to
# convert it to json
locals {
    aws_cred = "${jsondecode(data.conjur_secret.aws_creds.value)}"
}


provider "aws" {
    region      = "eu-central-1" # Update region
    access_key  = local.aws_cred.data.access_key_id
    secret_key  = local.aws_cred.data.secret_access_key
    token       = local.aws_cred.data.session_token
}


# Demo, create a S3 bucket
resource "aws_s3_bucket" "example" {
  bucket = "dynamic-tf-creds-bucket"
}
