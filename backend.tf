terraform {
  backend "s3" {
    bucket  = "demo-backend"
    key     = "setu/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}