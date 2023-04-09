terraform {
  backend "s3" {
    bucket  = "demo-backend"
    key     = "<s3-backend-bucket>/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
