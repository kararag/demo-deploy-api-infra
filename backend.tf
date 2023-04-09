terraform {
  backend "s3" {
    bucket  = "demo-backend"
    key     = "sample-app-demo/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
