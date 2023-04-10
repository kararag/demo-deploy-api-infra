# This was created and tested with version -> 0.15.0. 

terraform {
    required_version = ">= 0.12.14"
}

provider "aws" {
  region = var.region
}
