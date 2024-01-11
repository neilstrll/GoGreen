# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "bucket name"
    key       = "gogreen.tfstate"
    region    = "us-west-2"
    profile   = "terraform-user"
  }
}