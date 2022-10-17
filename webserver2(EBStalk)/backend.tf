//storing the state file in the s3 backend
terraform {
  backend "s3" {
    bucket = "mybinusbucket"
    key    = "terraform/backend"
    region = "ap-south-1"
  }
}